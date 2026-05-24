import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';

import '../constants/app_constants.dart';
import '../database/collections/letter_progress.dart';
import '../database/collections/rewards_data.dart';
import '../database/collections/session_data.dart';
import '../database/isar_service.dart';
import '../firebase/firebase_service.dart';

class SyncService {
  SyncService._();

  static final SyncService instance = SyncService._();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;

  void startConnectivityListener() {
    _connectivitySub ??= Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline && _wasOffline) {
        syncAll();
      }
      _wasOffline = !isOnline;
    });
  }

  Future<void> syncAll() async {
    if (!FirebaseService.instance.isAuthenticated) return;
    await Future.wait([
      syncLetterProgress(),
      syncRewards(),
      syncSessions(),
    ]);
  }

  Future<void> syncLetterProgress() async {
    final uid = FirebaseService.instance.parentUserId;
    if (uid == null) return;

    try {
      final db = IsarService.instance.db;
      final fs = FirebaseService.instance.firestore;
      final lettersCol = fs
          .collection(AppConstants.fsUsers)
          .doc(uid)
          .collection(AppConstants.fsProgressLetters);

      final localList = await db.letterProgress.where().anyId().findAll();
      final localMap = {for (final lp in localList) lp.letter: lp};

      final remoteSnap = await lettersCol.get();
      final remoteMap = {for (final doc in remoteSnap.docs) doc.id: doc.data()};

      final allLetters = {...localMap.keys, ...remoteMap.keys};
      final batch = fs.batch();

      for (final letter in allLetters) {
        final local = localMap[letter];
        final remote = remoteMap[letter];

        final mergedCompleted = (local?.isCompleted ?? false) ||
            (remote?['isCompleted'] as bool? ?? false);

        final localAttempts = local?.tracingAttempts ?? 0;
        final remoteAttempts = remote?['tracingAttempts'] as int? ?? 0;
        final mergedAttempts =
            localAttempts > remoteAttempts ? localAttempts : remoteAttempts;

        DateTime? mergedCompletedAt;
        if (mergedCompleted) {
          mergedCompletedAt = local?.completedAt ??
              (remote?['completedAt'] as Timestamp?)?.toDate();
        }

        await db.writeTxn(() async {
          final existing = await db.letterProgress.getByLetter(letter);
          final lp = existing ?? (LetterProgress()..letter = letter);
          lp.isCompleted = mergedCompleted;
          lp.tracingAttempts = mergedAttempts;
          lp.completedAt = mergedCompletedAt;
          await db.letterProgress.put(lp);
        });

        batch.set(lettersCol.doc(letter), {
          'isCompleted': mergedCompleted,
          'tracingAttempts': mergedAttempts,
          'completedAt': mergedCompletedAt != null
              ? Timestamp.fromDate(mergedCompletedAt)
              : null,
        });
      }

      await batch.commit();
    } catch (_) {}
  }

  Future<void> syncRewards() async {
    final uid = FirebaseService.instance.parentUserId;
    if (uid == null) return;

    try {
      final db = IsarService.instance.db;
      final fs = FirebaseService.instance.firestore;
      final rewardsDoc = fs
          .collection(AppConstants.fsUsers)
          .doc(uid)
          .collection(AppConstants.fsProgressRewards)
          .doc('main');

      final local = await db.rewardsDatas.where().anyId().findFirst();
      final remoteSnap = await rewardsDoc.get();
      final remote = remoteSnap.data();

      final localStars = local?.totalStars ?? 0;
      final remoteStars = remote?['totalStars'] as int? ?? 0;
      final mergedStars = localStars > remoteStars ? localStars : remoteStars;

      final localBadges = local?.unlockedBadges ?? <String>[];
      final remoteBadges =
          (remote?['unlockedBadges'] as List<dynamic>?)?.cast<String>() ??
              <String>[];
      final mergedBadges = {...localBadges, ...remoteBadges}.toList();

      final mergedLevel =
          ((mergedStars ~/ AppConstants.starsToUnlockLevel) + 1).clamp(1, 4);

      await db.writeTxn(() async {
        final existing = await db.rewardsDatas.where().anyId().findFirst();
        final rd = existing ?? RewardsData();
        rd.totalStars = mergedStars;
        rd.currentLevel = mergedLevel;
        rd.unlockedBadges = mergedBadges;
        rd.lastUpdated = DateTime.now();
        await db.rewardsDatas.put(rd);
      });

      await rewardsDoc.set({
        'totalStars': mergedStars,
        'currentLevel': mergedLevel,
        'unlockedBadges': mergedBadges,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<void> syncSessions() async {
    final uid = FirebaseService.instance.parentUserId;
    if (uid == null) return;

    try {
      final db = IsarService.instance.db;
      final fs = FirebaseService.instance.firestore;
      final sessionsCol = fs
          .collection(AppConstants.fsUsers)
          .doc(uid)
          .collection(AppConstants.fsSessions);

      final localSessions = await db.sessionDatas.where().anyId().findAll();
      if (localSessions.isEmpty) return;

      final remoteSnap = await sessionsCol.get();
      final remoteIds = remoteSnap.docs.map((d) => d.id).toSet();

      final batch = fs.batch();
      for (final session in localSessions) {
        final docId = session.startTime.millisecondsSinceEpoch.toString();
        if (remoteIds.contains(docId)) continue;
        batch.set(sessionsCol.doc(docId), {
          'startTime': Timestamp.fromDate(session.startTime),
          'endTime': session.endTime != null
              ? Timestamp.fromDate(session.endTime!)
              : null,
          'starsEarned': session.starsEarned,
          'lettersAttempted': session.lettersAttempted,
        });
      }
      await batch.commit();
    } catch (_) {}
  }
}
