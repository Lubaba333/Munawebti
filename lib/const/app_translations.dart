import 'package:get/get.dart';


class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _en,
        'ar_SA': _ar,
      };

  static const Map<String, String> _en = {
    // ===== Common =====
    'save': 'Save',
    'cancel': 'Cancel',
    'edit': 'Edit',
    'delete': 'Delete',
    'submit': 'Submit',
    'no_data': 'No data found',
    'loading': 'Loading...',
    'back': 'Back',
    'password': 'Password',

    // ===== Onboarding =====
    'skip': 'Skip',
    'get_started': 'Get started',
    'onboarding_title_1': 'Manage Students Easily',
    'onboarding_desc_1':
        'Track and manage nursing students efficiently in school and housing.',
    'onboarding_title_2': 'Organize Schedules',
    'onboarding_desc_2':
        'Easily manage supervisors shifts and student schedules.',
    'onboarding_title_3': 'Hospital Training Tracking',
    'onboarding_desc_3':
        'Monitor students training and progress in hospitals in real-time.',

    // ===== Auth: Login =====
    'Munawebti':'Munawebti',
    'welcome_login': 'Welcome',
    'remember': 'Remember',
    'forgot_password': 'Forgot password?',
    'login': 'Login',

    // ===== Auth: Forget/Reset Password =====
    'reset_password': 'Reset Password',
    'enter_email_receive_otp': 'Enter your email to receive OTP code',
    'send_otp': 'Send OTP',
    'back_to_login': 'Back to Login',
    'create_new_password': 'Create New Password',
    'enter_new_password_below': 'Enter your new password below',
    'new_password': 'New Password',
    'confirm_password': 'Confirm Password',

    // ===== Auth: OTP =====
    'verification_code': 'Verification Code',
    'enter_otp_sent_to_email': 'Enter OTP code sent to email',
    'verify_code': 'Verify Code',

    // ===== Settings =====
    'settings': 'Settings',
    'appearance': 'Appearance',
    'dark_mode': 'Dark Mode',
    'currently_on': 'Currently on',
    'currently_off': 'Currently off',
    'language': 'Language',
    'about': 'About',
    'about_app': 'About App',
    'about_app_subtitle': 'Version, developer info',
    'about_description':
        'An app for supervisors to manage students, schedules, requests and emergencies.',

    // ===== Home =====
    'welcome': 'Welcome 👋',
    'current_shift': 'Current Shift',
    'no_shift': 'No Shift',
    'active_now': 'Active Now',
    'quick_actions': 'Quick Actions',
    'emergency': 'Emergency',
    'complaints': 'Complaints',
    'requests': 'Requests',
    'attendance': 'Attendance',
    'todays_schedule': "Today's Schedule",

    // ===== Schedule =====
    'my_schedule': 'My Schedule',
    'lecture': 'Lecture',
    'housing': 'Housing',
    'time': 'Time',
    'lecturer': 'Lecturer',
    'location': 'Location',
    'class_label': 'Class',
    'dormitory': 'Dormitory',
    'take_attendance': 'Take Attendance',

    // ===== Students =====
    'students': 'Students',
    'all': 'All',
    'resident': 'Resident',
    'non_resident': 'Non Resident',
    'search_student': 'Search for a student...',
    'no_students': 'No students found',
    'student_id': 'Student ID',
    'specialization': 'Specialization',
    'email': 'Email',
    'phone': 'Phone',
    'year': 'Year',
    'Name':'Name',

    // ===== Warnings / Violations / Rewards / Reports =====
    'warnings': 'Warnings',
    'violations': 'Violations',
    'rewards': 'Rewards',
    'reports': 'Reports',
    'add_warning': 'Add Warning',
    'add_violation': 'Add Violation',
    'add_reward': 'Add Reward',
    'add_report': 'Add Report',
    'description': 'Description',
    'possible_penalty': 'Possible Penalty',
    'penalty': 'Penalty',
    'category': 'Category',
    'warning_date': 'Warning Date',
    'violation_date': 'Violation Date',

    // ===== Emergency =====
    'emergency_cases': 'Emergency Cases',
    'No emergency_cases':'No emergency_cases',
    'new_emergency': 'New Emergency',
    'send_emergency': 'Send Emergency',
    'select_student': 'Select Student',
    'emergency_details': 'Emergency Details',
    'student_information': 'Student Information',
    'emergency_status': 'Emergency Status',
    'status': 'Status',
    'severity':'severity',

    // ===== Requests =====
    'request_details': 'Request Details',
    'admin_response': 'Admin Response',
    'additional_information': 'Additional Information',
    'create_request': 'Create Request',

    // ===== Complaints =====
    'new_complaint': 'New Complaint',
    'title': 'Title',
    'type': 'Type',
    'New':'New',
    'Administration response':'Administration response',
    'NO reply at this time':'NO reply at this time',


    // ===== Profile =====
    'profile': 'Profile',
    'logout': 'Logout',
    'performance_records': 'Performance Records',
    'supervisor_id': 'Supervisor ID',
    'university': 'University',
    'certificate_date': 'Certificate Date',
  };

  static const Map<String, String> _ar = {
    // ===== Common =====
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'edit': 'تعديل',
    'delete': 'حذف',
    'submit': 'إرسال',
    'no_data': 'لا توجد بيانات',
    'loading': 'جاري التحميل...',
    'back': 'رجوع',
    'password': 'كلمة المرور',

    // ===== Onboarding =====
    'skip': 'تخطي',
    'get_started': 'ابدأ الآن',
    'onboarding_title_1': 'إدارة الطلاب بسهولة',
    'onboarding_desc_1':
        'تتبع وإدارة طلاب التمريض بكفاءة بالمدرسة والسكن.',
    'onboarding_title_2': 'تنظيم الجداول',
    'onboarding_desc_2':
        'إدارة مناوبات المشرفين وجداول الطلاب بسهولة.',
    'onboarding_title_3': 'تتبع التدريب بالمستشفى',
    'onboarding_desc_3':
        'متابعة تدريب الطلاب وتقدمهم بالمستشفيات بشكل لحظي.',

    // ===== Auth: Login =====
    'Munawebti':'مناوبتي',
    'welcome_login': 'أهلاً بك',
    'remember': 'تذكرني',
    'forgot_password': 'نسيت كلمة المرور؟',
    'login': 'تسجيل الدخول',

    // ===== Auth: Forget/Reset Password =====
    'reset_password': 'إعادة تعيين كلمة المرور',
    'enter_email_receive_otp': 'أدخل بريدك الإلكتروني ليصلك رمز التحقق',
    'send_otp': 'إرسال الرمز',
    'back_to_login': 'العودة لتسجيل الدخول',
    'create_new_password': 'إنشاء كلمة مرور جديدة',
    'enter_new_password_below': 'أدخل كلمة المرور الجديدة أدناه',
    'new_password': 'كلمة المرور الجديدة',
    'confirm_password': 'تأكيد كلمة المرور',

    // ===== Auth: OTP =====
    'verification_code': 'رمز التحقق',
    'enter_otp_sent_to_email': 'أدخل رمز التحقق المرسل لبريدك الإلكتروني',
    'verify_code': 'تحقق من الرمز',

    // ===== Settings =====
    'settings': 'الإعدادات',
    'appearance': 'المظهر',
    'dark_mode': 'الوضع الليلي',
    'currently_on': 'مفعّل حاليًا',
    'currently_off': 'غير مفعّل',
    'language': 'اللغة',
    'about': 'حول',
    'about_app': 'حول التطبيق',
    'about_app_subtitle': 'الإصدار، معلومات المطوّر',
    'about_description':
        'تطبيق للمشرفين لإدارة الطلاب، الجداول، الطلبات وحالات الطوارئ.',

    // ===== Home =====
    'welcome': 'أهلاً 👋',
    'current_shift': 'المناوبة الحالية',
    'no_shift': 'لا توجد مناوبة',
    'active_now': 'نشط الآن',
    'quick_actions': 'إجراءات سريعة',
    'emergency': 'طوارئ',
    'complaints': 'الشكاوى',
    'requests': 'الطلبات',
    'attendance': 'الحضور',
    'todays_schedule': 'جدول اليوم',

    // ===== Schedule =====
    'my_schedule': 'جدولي',
    'lecture': 'محاضرة',
    'housing': 'سكن',
    'time': 'الوقت',
    'lecturer': 'المحاضر',
    'location': 'المكان',
    'class_label': 'الشعبة',
    'dormitory': 'السكن',
    'take_attendance': 'تسجيل الحضور',

    // ===== Students =====
    'students': 'الطلاب',
    'all': 'الكل',
    'resident': 'مقيم',
    'non_resident': 'غير مقيم',
    'search_student': 'ابحث عن طالب...',
    'no_students': 'لا يوجد طلاب',
    'student_id': 'الرقم الجامعي',
    'specialization': 'الاختصاص',
    'email': 'البريد',
    'phone': 'الهاتف',
    'year': 'السنة',
    'Name':'الاسم',

    // ===== Warnings / Violations / Rewards / Reports =====
    'warnings': 'التحذيرات',
    'violations': 'المخالفات',
    'rewards': 'المكافآت',
    'reports': 'التقارير',
    'add_warning': 'إضافة تحذير',
    'add_violation': 'إضافة مخالفة',
    'add_reward': 'إضافة مكافأة',
    'add_report': 'إضافة تقرير',
    'description': 'الوصف',
    'possible_penalty': 'العقوبة المحتملة',
    'penalty': 'العقوبة',
    'category': 'التصنيف',
    'warning_date': 'تاريخ التحذير',
    'violation_date': 'تاريخ المخالفة',

    // ===== Emergency =====
    'emergency_cases': 'حالات الطوارئ',
    'No emergency_cases':'لا يوجد حالات طارئة',
    'new_emergency': 'حالة طوارئ جديدة',
    'send_emergency': 'إرسال حالة الطوارئ',
    'select_student': 'اختر الطالب',
    'severity':'خطورة',
    'case Type':'',
    'emergency_details': 'تفاصيل الطوارئ',
    'student_information': 'معلومات الطالب',
    'emergency_status': 'حالة الطوارئ',
    'status': 'الحالة',

    // ===== Requests =====
    'request_details': 'تفاصيل الطلب',
    'admin_response': 'رد الإدارة',
    'additional_information': 'معلومات إضافية',
    'create_request': 'إنشاء طلب',

    // ===== Complaints =====
    'new_complaint': 'شكوى جديدة',
    'title': 'العنوان',
    'type': 'النوع',
    'New':'إضافة',
    'Administration response':'رد الإدارة',
    'NO reply at this time':'لا يوجد رد حاليا',


    // ===== Profile =====
    'profile': 'الملف الشخصي',
    'logout': 'تسجيل الخروج',
    'performance_records': 'سجل الأداء',
    'supervisor_id': 'رقم المشرف',
    'university': 'الجامعة',
    'certificate_date': 'تاريخ الشهادة',
  };
}
