import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {

    'ar': {

      // عامة
      'ok': 'تم',
      'error': 'خطأ',
      'warning': 'تنبيه',
      'success': 'تم بنجاح',
      'details': 'تفاصيل',
      'description': 'الوصف',
      'date': 'التاريخ',
      'status': 'الحالة',
      'note': 'ملاحظة',
      'loading': 'جاري التحميل...',
      'not_specified': 'غير محدد',

      // الأيام
      'monday': 'الاثنين',
      'tuesday': 'الثلاثاء',
      'wednesday': 'الأربعاء',
      'thursday': 'الخميس',
      'friday': 'الجمعة',
      'saturday': 'السبت',
      'sunday': 'الأحد',

      // السكن
      'building_1': 'مبنى الطالبات الأول',
      'building_2': 'مبنى الطالبات الثاني',
      'building_3': 'مبنى الطالبات الثالث',
      'not_assigned': 'غير مخصصة بعد',
      'not_resident': 'غير مقيمة بالسكن',

      // المحاضرات
      'next_lecture_loading': 'جاري تحميل المحاضرة القادمة...',
      'no_upcoming_lectures': 'لا توجد محاضرات قادمة',
      'theoretical': 'نظري',
      'practical': 'عملي',

      // الطوارئ
      'emergency': 'بلاغ طوارئ',
      'emergency_report': 'إرسال بلاغ طوارئ',
      'emergency_title': 'عنوان الطوارئ (مثال: عطل كهربائي)',
      'emergency_description': 'وصف تفصيلي للموقف...',
      'send_report': 'إرسال البلاغ',
      'sending': 'جاري الإرسال...',
      'fill_all_fields': 'يرجى ملء جميع الحقول',
      'report_sent': 'تم استلام بلاغ الطوارئ وسيتم معالجته فوراً',
      'report_failed': 'فشل الإرسال',
      'report_details': 'تفاصيل البلاغ',
      'official_report': 'بلاغ طوارئ رسمي',
      'new_report': 'بلاغ جديد',
      'processing': 'قيد المعالجة',
      'resolved': 'تم الحل',
        // ================= Authentication =================
  'welcome': 'مرحباً بك',
  'welcome_back': 'أهلاً بعودتك',
  'login': 'تسجيل الدخول',
  'Sign in': 'تسجيل الدخول',
  'register': 'إنشاء حساب',
  'Sign up': 'إنشاء حساب',
  'logout': 'تسجيل الخروج',
  'email': 'البريد الإلكتروني',
  'password': 'كلمة المرور',
  'confirm_password': 'تأكيد كلمة المرور',
  'user_name': 'الاسم الكامل',
  'phone_number': 'رقم الهاتف',
 'phone':'رقم الهاتف',
  'annual_average': 'المعدل السنوي',
  'dormitory_status': 'حالة السكن',
  'year': 'السنة الدراسية',
  'specialization': 'التخصص',
  'student_number': 'الرقم الجامعي',
  'forgot_password': 'نسيت كلمة المرور؟',
  'remember_me': 'تذكرني',
  'dont_have_account': 'ليس لديك حساب؟',
  'already_have_account': 'لديك حساب بالفعل؟',
  'Sign in': 'تسجيل الدخول',
  'Sign up': 'إنشاء حساب',
  'verify': 'تحقق',
  'verification_code': 'رمز التحقق',
  'resend_code': 'إعادة إرسال الرمز',
  'email_verified': 'تم التحقق من البريد الإلكتروني',
  'email_not_verified': 'البريد الإلكتروني غير مؤكد',
  'account_created': 'تم إنشاء الحساب بنجاح',
  'login_failed': 'فشل تسجيل الدخول',
  'register_failed': 'فشل إنشاء الحساب',
  'verification_failed': 'فشل التحقق',
  'invalid_credentials': 'بيانات الدخول غير صحيحة',
  'passwords_not_match': 'كلمتا المرور غير متطابقتين',
  'invalid_email': 'البريد الإلكتروني غير صالح',
  'required_field': 'هذا الحقل مطلوب',
  'create_account': 'إنشاء حساب',

  // ================= Welcome =================
  'Welcome to Studants App': 'مرحباً بك في تطبيق الطالبات',
  
'A platform designed for students to access their services with ease.\nStay informed, manage your requests, and simplify your academic experience.\nEverything you need, all in one place.':
'منصة مصممة لمساعدة الطلاب على الوصول إلى خدماتهم بسهولة.\nابقَ على اطلاع، وأدر طلباتك، واجعل تجربتك الأكاديمية أكثر سهولة.\nكل ما تحتاجه، في مكان واحد.',
  // ================= Profile =================
  'profile': 'الملف الشخصي',
  'edit_profile': 'تعديل الملف الشخصي',
  'personal_information': 'المعلومات الشخصية',
  'change_photo': 'تغيير الصورة',
  'save_changes': 'حفظ التعديلات',
  'name': 'الاسم',
  'gender': 'الجنس',
  'birth_date': 'تاريخ الميلاد',
  'college': 'الكلية',
  'department': 'القسم',
  'academic_year': 'السنة الدراسية',
  'address': 'العنوان',
  'nationality': 'الجنسية',
  'male': 'ذكر',
  'female': 'أنثى',

  // ================= Settings =================
  'settings': 'الإعدادات',
  'language': 'اللغة',
  'change_language': 'تغيير اللغة',
  'theme': 'المظهر',
  'light_mode': 'الوضع الفاتح',
  'dark_mode': 'الوضع الداكن',
  'about_app': 'حول التطبيق',
  'version': 'الإصدار',
  'privacy_policy': 'سياسة الخصوصية',
  'terms': 'الشروط والأحكام',
  'request': 'طلب',
  'request_type': 'نوع الطلب',
  'request_details': 'تفاصيل الطلب',
  'request_status': 'حالة الطلب',
  'request_reason': 'سبب الطلب',
  'request_date': 'تاريخ الطلب',
  'send_request': 'إرسال الطلب',
  'cancel_request': 'إلغاء الطلب',
  'incoming': 'واردة',
  'no_requests': 'لا توجد طلبات حالياً',
'student_id': 'الرقم الجامعي',
  'pending': 'قيد الانتظار',
  'approved': 'مقبول',
  'rejected': 'مرفوض',

  'current_room': 'غرفتك الحالية',
  'current_room_loading': 'لم يتم تحميل الغرفة الحالية بعد',
  'room': 'الغرفة',
  'unit': 'الوحدة',

  'reason': 'السبب',
  'write_reason': 'اكتبي السبب',
  'reason_required': 'السبب مطلوب',

  'choose_room': 'اختاري الغرفة',
  'choose_unit': 'اختاري الوحدة السكنية',
  'choose_student': 'اختاري الطالبة',

  'available_rooms': 'الغرف المتاحة',

  'send': 'إرسال',
   'room_transfer': 'نقل بدون بديلة',

  'room_transfer_desc':
      'سيتم إرسال طلب نقل للإدارة، والإدارة تحدد الغرفة المناسبة حسب الشواغر.',

  'room_transfer_reason':
      'سبب طلب النقل',

  'send_room_transfer':
      'إرسال طلب النقل',

  'specific_room_change':
      'تبديل لغرفة محددة',

  'specific_room_change_desc':
      'اختاري الوحدة السكنية أولاً ثم الغرفة المطلوبة.',

  'specific_room_reason':
      'سبب تبديل الغرفة',

  'send_room_change':
      'إرسال الطلب',

  'choose_building_first':
      'اختاري الوحدة أولاً لعرض الغرف',

  'no_rooms':
      'لا توجد غرف متاحة',

  'no_rooms_in_building':
      'لا توجد غرف متاحة في هذه الوحدة',
      'exchange_request':'طلب تبديل',

'exchange_student':'الطالبة الأخرى',

'choose_exchange_student':'اختاري الطالبة',

'exchange_reason':'سبب التبديل',

'send_exchange_request':'إرسال طلب التبديل',

'waiting_other_student':
'بانتظار موافقة الطالبة الأخرى',
'complaints':'الشكاوى',

'complaint':'شكوى',

'new_complaint':'إضافة شكوى',

'create_complaint':'إنشاء شكوى',

'complaint_title':'عنوان الشكوى',

'complaint_description':'تفاصيل الشكوى',

'complaint_type':'نوع الشكوى',

'submit_complaint':'إرسال الشكوى',

'complaint_details':'تفاصيل الشكوى',

'complaint_status':'حالة الشكوى',

'complaint_created':'تاريخ الشكوى',

'my_complaints':'شكاواي',

'no_complaints':'لا توجد شكاوى',

'complaint_sent':'تم إرسال الشكوى بنجاح',

'complaint_closed':'تم حل الشكوى',

'complaint_open':'مفتوحة',

'complaint_processing':'قيد المعالجة',

'complaint_resolved':'تم الحل',

'complaint_rejected':'مرفوضة',
'warnings':'تنبيهاتي',



'warning_details':'تفاصيل التنبيه',

'official_warning':'تنبيه رسمي',

'warning_description':'الوصف',

'warning_date':'تاريخ التنبيه',

'possible_penalty':'العقوبة المحتملة',

'supervisor':'المشرف',

'no_warnings':'لا توجد تنبيهات',

'no_warning_message':'لا يوجد أي تنبيه مسجل حالياً',

'view_details':'تفاصيل',
'violations':'مخالفاتي',

'violation':'مخالفة',

'violation_details':'تفاصيل المخالفة',

'official_violation':'مخالفة رسمية',

'violation_description':'الوصف',

'violation_category':'التصنيف',

'violation_date':'تاريخ المخالفة',

'penalty':'العقوبة',

'creator':'المشرف',

'no_violations':'لا توجد مخالفات',

'no_violation_message':'حسابك لا يحتوي على أي مخالفات حالياً',
'home':'الرئيسية',

'next_lecture':'المحاضرة القادمة',

'hospital':'المشفى',

'location':'الموقع',

'time':'الوقت',

'day':'اليوم',

'my_lectures':'محاضراتي',

'my_requests': 'طلباتي',

'services':'الخدمات',

'notifications':'الإشعارات',



'home_page':'الصفحة الرئيسية',

'no_data':'لا توجد بيانات',

'refresh':'تحديث',
'lecture':'محاضرة',

'lectures':'المحاضرات',

'lecture_details':'تفاصيل المحاضرة',

'lecture_type':'نوع المحاضرة',

'attendance':'الحضور',

'absence':'الغياب',

'present':'حاضر',

'absent':'غائب',

'doctor':'الدكتور',

'subject':'المادة',

'section':'الشعبة',
'notification':'إشعار',



'mark_all_read':'تحديد الكل كمقروء',

'no_notifications':'لا توجد إشعارات',

'new_notification':'إشعار جديد',
'service':'خدمة',



'emergency_service':'الطوارئ',

'complaint_service':'الشكاوى',

'room_transfer_service':'نقل الغرف',

'room_exchange_service':'تبديل الغرف',

'warning_service':'التنبيهات',

'violation_service':'المخالفات',

'reward_service':'المكافآت',
'about':'حول التطبيق',

'app_version':'إصدار التطبيق',



'light':'فاتح',

'dark':'داكن',



'logout_question':'هل تريد تسجيل الخروج؟',

'yes':'نعم',

'no':'لا',
'rewards':'المكافآت',

'reward':'مكافأة',

'no_rewards':'لا توجد مكافآت',

'reward_details':'تفاصيل المكافأة',
'search':'بحث',

'save':'حفظ',

'edit':'تعديل',

'delete':'حذف',

'close':'إغلاق',

'back':'رجوع',

'next':'التالي',

'finish':'إنهاء',

'accept':'قبول',

'reject':'رفض',

'cancel':'إلغاء',

'confirm':'تأكيد',

'choose':'اختر',

'student':'الطالبة',

'students':'الطالبات',

'building':'المبنى',
'number': 'الرقم',
// ar
'inside_dormitory': 'داخل السكن',
'dormitory_unit': 'الوحدة السكنية',
'outside_dormitory': 'خارج السكن',
'dormitory_attendance_details': 'تفاصيل حضور السكن',
'view_attendance_record_details': 'عرض سجل الحضور بالتفصيل',
// ar
'dormitory_attendance': 'حضور السكن',
'dormitory_attendance_record': 'سجل حضور السكن',
'lecture_attendance_record': 'سجل حضور المحاضرات',
'dormitory_attendance_subtitle': 'سجل دخولك وخروجك من السكن',
'no_dormitory_attendance_records': 'لا توجد سجلات حضور سكن',
// ar
'emergency_create_subtitle': 'يرجى وصف الحالة بدقة ليتم التعامل معها بسرعة',
'emergency_notice': 'سيتم إشعار الإدارة فوراً. في الحالات الحرجة يرجى التواصل مباشرة مع المشرفة.',
// ar
'created_at': 'تاريخ الإنشاء',
'report_status': 'حالة البلاغ',
'emergency_details_subtitle': 'عرض معلومات بلاغ الطوارئ',
'emergency_under_review_note': 'بلاغك قيد المراجعة من قبل الإدارة. سيتم التواصل معك فور توفر تحديث.',
// ar
'emergency_cases': 'حالات الطوارئ',
'emergency_cases_subtitle': 'تابعي البلاغات وحالة المعالجة',
'no_emergency_reports': 'لا توجد بلاغات طوارئ سابقة',
'emergency_reports_hint': 'عند إرسال بلاغ جديد سيظهر هنا',
// ar
'complaint_details_subtitle': 'عرض معلومات الشكوى كاملة',
'official_housing_complaint': 'شكوى سكن رسمية',
'complaint_under_review_note': 'سيتم معالجة شكواك قريباً من قبل الإدارة',
// ar
'new_housing_complaint': 'إضافة شكوى جديدة',
'housing_complaint_create_subtitle': 'اكتبي تفاصيل الشكوى بوضوح ليتم التعامل معها بشكل أسرع',
'fill_title_and_description': 'يرجى تعبئة العنوان والوصف',
'housing_complaint_notice': 'سيتم إرسال الشكوى للإدارة، ويمكنك متابعة حالتها من صفحة شكاوى السكن.',
// ar
'housing_complaints': 'شكاوى السكن',
'housing_complaint': 'شكوى السكن',
'housing_complaints_subtitle': 'تابعي الشكاوى وحالة معالجتها',
'no_housing_complaints': 'لا يوجد شكاوى بعد',
'housing_complaints_empty_hint': 'عند إضافة شكوى جديدة ستظهر هنا',
// ar
'no_incoming_requests': 'لا توجد طلبات واردة',
'incoming_exchange_request': 'طلب تبديل وارد',
'waiting_for_your_response': 'بانتظار ردك',
'reject_exchange_request': 'رفض طلب التبديل',
'rejection_reason': 'سبب الرفض',
'you_approved_request_waiting_admin': 'وافقتِ على الطلب بانتظار موافقة الإدارة',
'you_rejected_request_cancelled': 'تم رفض الطلب وإلغاؤه',
'admin_approved': 'وافقت الإدارة',
'admin_rejected': 'رفضت الإدارة',
"new_request":"طلب جديد",
'  lecture_attendance _record': 'سجل حضور المحاضرات',
  '  dormitory_attendance  _record': 'سجل حضور السكن',
  'day/time': 'اليوم/الوقت',
  'my_lectures_schedule': 'جدول المحاضرات',
  'type':'نوع المحاضرة',
  'group':' الفئة',
   'title_type':' عنوان الطلب ',
   'target_student_room':'الغرفة البديلة',
   'requester_student': 'الطالبة مقدمة الطلب',
'target_student': 'الطالبة البديلة',
'unknown_room': 'غرفة غير معروفة',
'requested_room': 'الغرفة المطلوبة',

'admin_notes': 'ملاحظات الإدارة',
'admin_response': 'رد الإدارة',

'exit_permission': 'طلب إذن خروج',
'exit_reason': 'سبب الخروج',
'exit_date': 'تاريخ الخروج',
'from_hour': 'من الساعة',
'to_hour': 'حتى الساعة',

'transfer_reason': 'سبب النقل',
'target_student_rejection_reason':'سبب رفض الطالبة ',
'target_student_approved_at':'وافقت الطالبة في',
'exit_from_dormitory_permission':'طلب اذن خروج',
'room_change_without_alternative': 'طلب تبديل غرفة بدون بديلة',
'room_exchange_with_student':'طلب تبديل غرفة مع بديلة',
'transfer_to_any_available_room':'طلب نقل إلى أي غرفة متاحة',
'otp_sent': 'تم إرسال الرمز',
'verification_code_sent': 'تم إرسال رمز التحقق إلى',
'failed_send_otp': 'فشل في إرسال الرمز',
'email_verified_success': 'تم التحقق من البريد الإلكتروني! يمكنك الآن إكمال التسجيل',
'verify_email_first': 'يرجى التحقق من بريدك الإلكتروني أولاً بإدخال رمز التحقق',
 
'failed_fetch_emergency_data': 'فشل في جلب بيانات الطوارئ',
'failed_fetch_report_details': 'فشل في جلب تفاصيل البلاغ',
'failed_load_details': 'فشل تحميل التفاصيل',
 
'please_select_student': 'يرجى اختيار الطالبة',
'swap_request_sent': 'تم إرسال طلب التبديل',
 
'cannot_select_same_room': 'لا يمكن اختيار نفس غرفتك الحالية',
'write_room_transfer_reason': 'اكتبي سبب طلب تبديل الغرفة',
'write_transfer_reason': 'اكتبي سبب طلب النقل',
'cannot_exchange_same_room': 'لا يمكن التبديل مع نفس غرفتك الحالية',
'write_exchange_reason': 'اكتبي سبب طلب التبديل',
'exit_request_success': 'تم تسجيل طلب سماح الخروج بنجاح',
'room_change_request_success': 'تم إرسال طلب تبديل الغرفة بنجاح',
'transfer_request_success': 'تم تسجيل طلب النقل بنجاح',
'exchange_request_success': 'تم تسجيل طلب التبديل مع طالبة بنجاح',
'pending_exchange_exists': 'يوجد طلب تبديل سابق قيد الانتظار مع هذه الطالبة',
'cannot_send_request': 'تعذر إرسال الطلب',
'exchange_approved_admin': 'تم قبول الطلب وتحويله للإدارة',
'exchange_rejected_success': 'تم رفض الطلب',
'request_cancelled_success': 'تم إلغاء الطلب بنجاح',
'cannot_cancel_request': 'تعذر إلغاء الطلب',
'request_details_not_loaded': 'لم يتم تحميل تفاصيل الطلب',
 
'enter_email': 'الرجاء إدخال بريدك الإلكتروني',
'enter_valid_email': 'الرجاء إدخال بريد إلكتروني صحيح',
'email_not_found_retry': 'البريد الإلكتروني غير موجود، يرجى طلب رمز جديد',
'enter_otp_6digits': 'الرجاء إدخال رمز التحقق المكون من 6 أرقام',
'code_verified_success': 'تم التحقق من الرمز بنجاح',
'enter_new_password': 'الرجاء إدخال كلمة المرور الجديدة',
'password_min_length': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
'verify_otp_first': 'يرجى التحقق من رمز التحقق أولاً',
'password_changed_success': 'تم تغيير كلمة المرور بنجاح! يرجى تسجيل الدخول بكلمة المرور الجديدة',
'reset_failed': 'فشل إعادة التعيين',
 
'weak_name': 'الاسم ضعيف',
'invalid_email_format': 'إيميل غير صحيح',
'failed_load_complaint_details': 'فشل تحميل التفاصيل',

    },

    'en': {

      // General
      'ok': 'Done',
      'error': 'Error',
      'warning': 'Warning',
      'success': 'Success',
      'details': 'Details',
      'description': 'Description',
      'date': 'Date',
      'status': 'Status',
      'note': 'Note',
      'loading': 'Loading...',
      'not_specified': 'Not specified',

      // Days
      'monday': 'Monday',
      'tuesday': 'Tuesday',
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',

      // Dormitory
      'building_1': 'First Girls Building',
      'building_2': 'Second Girls Building',
      'building_3': 'Third Girls Building',
      'not_assigned': 'Not Assigned',
      'not_resident': 'Not Resident',

      // Lectures
      'next_lecture_loading': 'Loading next lecture...',
      'no_upcoming_lectures': 'No upcoming lectures',
      'theoretical': 'Theoretical',
      'practical': 'Practical',

      // Emergency
      'emergency': 'Emergency',
      'emergency_report': 'Send Emergency Report',
      'emergency_title': 'Emergency Title (e.g. Electrical Failure)',
      'emergency_description': 'Describe the situation...',
      'send_report': 'Send Report',
      'sending': 'Sending...',
      'fill_all_fields': 'Please fill all fields',
      'report_sent': 'Your emergency report has been received.',
      'report_failed': 'Sending failed',
      'report_details': 'Report Details',
      'official_report': 'Official Emergency Report',
      'new_report': 'New Report',
      'processing': 'Under Processing',
      'resolved': 'Resolved',
       // ================= Authentication =================
  'welcome': 'Welcome',
  'welcome_back': 'Welcome Back',
  'login': 'Login',
  'register': 'Register',
  'logout': 'Logout',
  'email': 'Email',
  'password': 'Password',
  'confirm_password': 'Confirm Password',
  'full_name': 'Full Name',
  'phone number': 'Phone Number',
  'student_number': 'Student Number',
  'forgot_password': 'Forgot Password?',
  'remember_me': 'Remember Me',
  'dont_have_account': "Don't have an account?",
  'already_have_account': 'Already have an account?',
  'sign_in': 'Sign In',
  'sign_up': 'Sign Up',
  'verify': 'Verify',
  'verification_code': 'Verification Code',
  'resend_code': 'Resend Code',
  'email_verified': 'Email Verified',
  'email_not_verified': 'Email Not Verified',
  'account_created': 'Account created successfully',
  'login_failed': 'Login Failed',
  'register_failed': 'Registration Failed',
  'verification_failed': 'Verification Failed',
  'invalid_credentials': 'Invalid Credentials',
  'passwords_not_match': 'Passwords do not match',
  'invalid_email': 'Invalid Email',
  'required_field': 'Required Field',

  // ================= Welcome =================
  'welcome_title': 'Welcome to Studants App',
  'welcome_description':
      'A platform designed for students to access their services easily.',
    'A platform designed for students to access their services with ease.\nStay informed, manage your requests, and simplify your academic experience.\nEverything you need, all in one place.':
'A platform designed for students to access their services with ease.\nStay informed, manage your requests, and simplify your academic experience.\nEverything you need, all in one place.',

  // ================= Profile =================
  'profile': 'Profile',
  'edit_profile': 'Edit Profile',
  'personal_information': 'Personal Information',
  'change_photo': 'Change Photo',
  'save_changes': 'Save Changes',
  'name': 'Name',
  'gender': 'Gender',
  'birth_date': 'Birth Date',
  'college': 'College',
  'department': 'Department',
  'academic_year': 'Academic Year',
  'address': 'Address',
  'nationality': 'Nationality',
  'male': 'Male',
  'female': 'Female',

  // ================= Settings =================
  'settings': 'Settings',
  'language': 'Language',
  'change_language': 'Change Language',
  'theme': 'Theme',
  'light_mode': 'Light Mode',
  'dark_mode': 'Dark Mode',
  'about_app': 'About App',
  'version': 'Version',
  'privacy_policy': 'Privacy Policy',
  'terms': 'Terms & Conditions',
   'requests': 'My Requests',
  'request': 'Request',
  'request_type': 'Request Type',
  'request_details': 'Request Details',
  'request_status': 'Request Status',
  'request_reason': 'Reason',
  'request_date': 'Request Date',
  'send_request': 'Send Request',
  'cancel_request': 'Cancel Request',

  'no_requests': 'No Requests',

  'pending': 'Pending',
  'approved': 'Approved',
  'rejected': 'Rejected',
'student_id': 'Student ID',
  'current_room': 'Current Room',
  'current_room_loading': 'Current room has not been loaded yet',

  'room': 'Room',
  'unit': 'Building',

  'reason': 'Reason',
  'write_reason': 'Write the reason',
  'reason_required': 'Reason is required',

  'choose_room': 'Choose Room',
  'choose_unit': 'Choose Building',
  'choose_student': 'Choose Student',

  'available_rooms': 'Available Rooms',

  'send': 'Send',
  'room_transfer': 'Transfer Without Replacement',

  'room_transfer_desc':
      'A transfer request will be sent to the administration. They will assign a suitable room based on availability.',

  'room_transfer_reason':
      'Transfer Reason',

  'send_room_transfer':
      'Send Transfer Request',

  'specific_room_change':
      'Specific Room Change',

  'specific_room_change_desc':
      'Choose the building first, then choose the desired room.',

  'specific_room_reason':
      'Reason for Room Change',

  'send_room_change':
      'Send Request',

  'choose_building_first':
      'Choose a building first',

  'no_rooms':
      'No Available Rooms',

  'no_rooms_in_building':
      'No available rooms in this building',
      'exchange_request':'Exchange Request',

'exchange_student':'Other Student',

'choose_exchange_student':'Choose Student',

'exchange_reason':'Exchange Reason',

'send_exchange_request':'Send Exchange Request',

'waiting_other_student':
'Waiting for the other students approval',
'complaints':'Complaints',

'complaint':'Complaint',

'new_complaint':'New Complaint',

'create_complaint':'Create Complaint',

'complaint_title':'Complaint Title',

'complaint_description':'Complaint Description',

'complaint_type':'Complaint Type',

'submit_complaint':'Submit Complaint',

'complaint_details':'Complaint Details',

'complaint_status':'Complaint Status',

'complaint_created':'Complaint Date',

'my_complaints':'My Complaints',

'no_complaints':'No Complaints',

'complaint_sent':'Complaint submitted successfully',

'complaint_closed':'Complaint Resolved',

'complaint_open':'Open',

'complaint_processing':'Under Processing',

'complaint_resolved':'Resolved',

'complaint_rejected':'Rejected',
'warnings':'My Warnings',



'warning_details':'Warning Details',

'official_warning':'Official Warning',

'warning_description':'Description',

'warning_date':'Warning Date',

'possible_penalty':'Possible Penalty',

'supervisor':'Supervisor',

'no_warnings':'No Warnings',

'no_warning_message':'No warnings found',

'view_details':'Details',
'violations':'My Violations',

'violation':'Violation',

'violation_details':'Violation Details',

'official_violation':'Official Violation',

'violation_description':'Description',

'violation_category':'Category',

'violation_date':'Violation Date',

'penalty':'Penalty',

'creator':'Supervisor',

'no_violations':'No Violations',

'no_violation_message':'Your account has no violations',
'home':'Home',

'next_lecture':'Next Lecture',

'hospital':'Hospital',

'location':'Location',

'time':'Time',

'day':'Day',

'my_lectures':'My Lectures',

'my_requests':'My Requests',

'services':'Services',

'notifications':'Notifications',



'home_page':'Home',

'no_data':'No Data',

'refresh':'Refresh',
'lecture':'Lecture',

'lectures':'Lectures',

'lecture_details':'Lecture Details',

'lecture_type':'Lecture Type',

'attendance':'Attendance',

'absence':'Absence',

'present':'Present',

'absent':'Absent',

'doctor':'Doctor',

'subject':'Subject',

'section':'Section',
'notification':'Notification',



'mark_all_read':'Mark all as read',

'no_notifications':'No Notifications',

'new_notification':'New Notification',
'service':'Service',



'emergency_service':'Emergency',

'complaint_service':'Complaints',

'room_transfer_service':'Room Transfer',

'room_exchange_service':'Room Exchange',

'warning_service':'Warnings',

'violation_service':'Violations',

'reward_service':'Rewards',
'about':'About',

'app_version':'App Version',





'light':'Light',

'dark':'Dark',



'logout_question':'Do you want to logout?',

'yes':'Yes',

'no':'No',
'rewards':'Rewards',

'reward':'Reward',

'no_rewards':'No Rewards',

'reward_details':'Reward Details',
'search':'Search',

'save':'Save',

'edit':'Edit',

'delete':'Delete',

'close':'Close',

'back':'Back',

'next':'Next',

'finish':'Finish',

'accept':'Accept',

'reject':'Reject',

'cancel':'Cancel',

'confirm':'Confirm',

'choose':'Choose',

'student':'Student',

'students':'Students',

'building':'Building',


// en
'lecture_attendance _record': 'Lecture Attendance Record',
  'dormitory_attendance  _record': 'Dormitory Attendance Record',
'dormitory_attendance': 'Dormitory Attendance',
'dormitory_attendance_subtitle': 'Your dormitory check-in and check-out record',
'no_dormitory_attendance_records': 'No dormitory attendance records',
'number':'Number',
// en
'inside_dormitory': 'Inside Dormitory',
'outside_dormitory': 'Outside Dormitory',
'dormitory_attendance_details': 'Dormitory Attendance Details',
'view_attendance_record_details': 'View attendance record details',
// en
'emergency_cases': 'Emergency Cases',
'emergency_cases_subtitle': 'Track your reports and their status',
'no_emergency_reports': 'No emergency reports yet',
'emergency_reports_hint': 'New reports will appear here',

// en
'created_at': 'Created At',
'report_status': 'Report Status',
'emergency_details_subtitle': 'View emergency report information',
'emergency_under_review_note': 'Your report is under review by the administration. You will be contacted once an update is available.',
// en
'emergency_create_subtitle': 'Please describe the situation accurately so it can be handled quickly',
'emergency_notice': 'The administration will be notified immediately. In critical cases, please contact the supervisor directly.',
// en
'complaint_details_subtitle': 'View full complaint information',
'official_housing_complaint': 'Official Housing Complaint',
'complaint_under_review_note': 'Your complaint will be handled soon by the administration',
// en
'housing_complaints': 'Housing Complaints',
'housing_complaint': 'Housing Complaint',
'housing_complaints_subtitle': 'Track complaints and their processing status',
'no_housing_complaints': 'No complaints yet',
'housing_complaints_empty_hint': 'New complaints will appear here',
// en
'no_incoming_requests': 'No Incoming Requests',
'incoming_exchange_request': 'Incoming Exchange Request',
'waiting_for_your_response': 'Waiting for Your Response',
'reject_exchange_request': 'Reject Exchange Request',
'rejection_reason': 'Rejection Reason',
'you_approved_request_waiting_admin': 'You approved the request. Waiting for admin approval.',
'you_rejected_request_cancelled': 'You rejected the request. It has been cancelled.',
'admin_approved': 'Approved by Admin',
'admin_rejected': 'Rejected by Admin',
'sign in': 'Sign in',
 'create_account': 'Create Account',
  'sign up': 'Sign up',
    'user_name': 'User Name',
  'phone_number': 'Phone Number',
  'year': 'Year',
  'specialization': 'Specialization',
  'lecture_attendance_record': 'Lecture_Attendance_Record',
  'dormitory_attendance_record': 'Dormitory_Attendance_Record',
  'day/time':'Day/Time',
  'my_lectures_schedule': 'My_Lecture_Schedule',
  'type':'Type',
  'group':'Group ',
  'target_student_room':'Target_Student_Room',
  'title_type':'Title_Type',
  'requester_student': 'Requesting Student',
'target_student': 'Replacement Student',
'unknown_room': 'Unknown Room',
'requested_room': 'Requested Room',
'admin_notes': 'Admin Notes',
'admin_response': 'Admin Response',
'exit_permission': 'Exit Permission',
'exit_reason': 'Exit Reason',
'exit_date': 'Exit Date',
'from_hour': 'From',
'to_hour': 'To',
'transfer_reason': 'Transfer Reason',
'target_student_rejection_reason':'Target_Student_Rejection_Reason',
'target_student_approved_at':'Target_Student_Approved_At',
'otp_sent': 'OTP Sent',
'verification_code_sent': 'Verification code sent to',
'failed_send_otp': 'Failed to Send OTP',
'email_verified_success': 'Email verified! You can now complete registration.',
'verify_email_first': 'Please verify your email first by entering the OTP code',
 
'failed_fetch_emergency_data': 'Failed to fetch emergency data',
'failed_fetch_report_details': 'Failed to fetch report details',
'failed_load_details': 'Failed to load details',
 
'please_select_student': 'Please select a student',
'swap_request_sent': 'Swap request sent',
 
'cannot_select_same_room': 'Cannot select your current room',
'write_room_transfer_reason': 'Please write the reason for room change',
'write_transfer_reason': 'Please write the reason for transfer',
'cannot_exchange_same_room': 'Cannot exchange with your current room',
'write_exchange_reason': 'Please write the exchange reason',
'exit_request_success': 'Exit permission request submitted successfully',
'room_change_request_success': 'Room change request sent successfully',
'transfer_request_success': 'Transfer request submitted successfully',
'exchange_request_success': 'Exchange request submitted successfully',
'pending_exchange_exists': 'There is already a pending exchange request with this student',
'cannot_send_request': 'Unable to send request',
'exchange_approved_admin': 'Request approved and forwarded to administration',
'exchange_rejected_success': 'Request rejected',
'request_cancelled_success': 'Request cancelled successfully',
'cannot_cancel_request': 'Unable to cancel request',
'request_details_not_loaded': 'Request details could not be loaded',
 
'enter_email': 'Please enter your email',
'enter_valid_email': 'Please enter a valid email',
'email_not_found_retry': 'Email not found. Please request OTP again.',
'enter_otp_6digits': 'Please enter the 6-digit OTP code',
'code_verified_success': 'Code verified successfully',
'enter_new_password': 'Please enter new password',
'password_min_length': 'Password must be at least 6 characters',
'verify_otp_first': 'Please verify your OTP code first',
'password_changed_success': 'Password changed successfully! Please login with your new password.',
'reset_failed': 'Reset Failed',
 
'weak_name': 'Name is too weak',
'invalid_email_format': 'Invalid email',
'failed_load_complaint_details': 'Failed to load details',
    },
  };
}