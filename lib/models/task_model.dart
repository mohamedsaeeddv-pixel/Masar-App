import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String taskNumber; // مثل DL-4829#
  final String clientName;
  final String location;
  final String amount;
  final String time;
  final String type; // تحصيل أو استرجاع

  TaskModel({
    required this.id,
    required this.taskNumber,
    required this.clientName,
    required this.location,
    required this.amount,
    required this.time,
    required this.type,
  });

  // تحويل البيانات من Firebase إلى Model
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      taskNumber: data['taskNumber'] ?? '',
      clientName: data['clientName'] ?? '',
      location: data['location'] ?? '',
      amount: data['amount'] ?? '',
      time: data['time'] ?? '',
      type: data['type'] ?? 'تحصيل',
    );
  }
}