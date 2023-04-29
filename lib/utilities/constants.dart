// Firestore Constants
class FirestoreConstants {
  //Collections
  static const usersCollection = 'users';
  static const adminsCollection = 'administrators';

  //Roles
  static const patient = 'Patient';
  static const doctor = 'Doctor';
}

class ModelFields {
  static const String email = 'email';
  static const String role = 'role';
  static const String prefix = 'prefix';
  static const String firstName = 'firstName';
  static const String middleName = 'middleName';
  static const String lastName = 'lastName';
  static const String suffix = 'suffix';
  static const String age = 'age';
  static const String birthDate = 'birthDate';
  static const String sex = 'sex';
  static const String phoneNumber = 'phoneNumber';
  static const String address = 'address';
  static const String civilStatus = 'civilStatus';
  static const String classification = 'classification';
  static const String uhsIdNumber = 'uhsIdNumber';
  static const String vaccinationStatus = 'vaccinationStatus';
  static const String isApproved = 'isApproved';
  static const String specialization = 'specialization';
  static const String lastLogin = 'lastLogin';
  static const String modifiedAt = 'modifiedAt';
  static const String createdAt = 'createdAt';
  static const String patientId = 'patientId';
  static const String doctorId = 'doctorId';
  static const String consultationRequestPatientTitle =
      'consultationRequestPatientTitle';
  static const String consultationRequestDoctorTitle =
      'consultationRequestDoctorTitle';
  static const String consultationRequestBody = 'consultationRequestBody';
  static const String status = 'status';
  static const String consultationType = 'consultationType';
  static const String consultationDateTime = 'consultationDateTime';
  static const String meetingId = 'meetingId';
  static const String patientAttachmentUrl = 'patientAttachmentUrl';
  static const String doctorAttachmentUrl = 'doctorAttachmentUrl';
  static const String id = 'id';
  static const String deviceTokens = 'deviceTokens';
  static const String title = 'title';
  static const String body = 'body';
  static const String sentAt = 'sentAt';
  static const String sender = 'sender';
  static const String isRead = 'isRead';
  static const String messages = 'messages';
  static const String message = 'message';
  static const String messageTimeStamp = 'messageTimeStamp';
  static const String senderName = 'senderName';
}
