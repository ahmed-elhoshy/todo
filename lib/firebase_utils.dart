import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/data_classes/my_users.dart';

import '../data_classes/tasks.dart';

class FirebaseUtils {
  /////////////////////// task data
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId);
    DocumentReference<Task> docRef = taskCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> editTask(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).update(task.toFireStore());
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> editIsDone(Task task, String uId) {
    return getTasksCollection(uId)
        .doc(task.id)
        .update({'isDone': !task.isDone!});
  }

  ///////////////////////      user data

  static CollectionReference<MyUsers> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUsers.collection)
        .withConverter<MyUsers>(
            fromFirestore: (snapshot, options) =>
                MyUsers.fromFireStore(snapshot.data()!),
            toFirestore: (MyUsers, options) => MyUsers.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUsers user) {
    var userCollection = getUsersCollection();
    DocumentReference<MyUsers> docRef = userCollection.doc(user.id);
    return docRef.set(user);
  }

  static Future<MyUsers?> readUserFromFireStore(String uId) async {
    var querySnapShot = await getUsersCollection().doc(uId).get();
    return querySnapShot.data();
  }
}
