
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../controller/attendance_history_controller.dart';
import '../models/attendance_history_model.dart';
import '../services/api_service.dart';

class AttendanceHistoryView extends StatefulWidget {
const AttendanceHistoryView({
super.key,
this.shiftType,
});

final String? shiftType;

@override
State<AttendanceHistoryView> createState() =>
_AttendanceHistoryViewState();
}

class _AttendanceHistoryViewState
extends State<AttendanceHistoryView> {

late final AttendanceHistoryController controller;

@override
void initState() {
super.initState();

controller = Get.put(
AttendanceHistoryController(
ApiService(),
shiftType: widget.shiftType,
),
);
}

@override
void dispose() {
if (Get.isRegistered<AttendanceHistoryController>()) {
Get.delete<AttendanceHistoryController>();
}

super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF6F7FB),
appBar: _buildAppBar(),
body: Obx(
() {
if (controller.isLoading.value &&
controller.history.isEmpty) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (controller.hasError &&
controller.history.isEmpty) {
return _buildErrorState();
}

if (!controller.hasData) {
return _buildEmptyState();
}

return RefreshIndicator(
onRefresh: controller.refreshHistory,
child: NotificationListener<ScrollNotification>(
onNotification: (notification) {
if (notification is ScrollUpdateNotification) {
if (notification.metrics.pixels >=
notification.metrics.maxScrollExtent - 250) {
controller.loadNextPage();
}
}

return false;
},
child: ListView(
physics: const AlwaysScrollableScrollPhysics(),
padding: const EdgeInsets.fromLTRB(
16,
16,
16,
30,
),
children: [
_buildSummaryCard(),

const SizedBox(height: 16),

_buildFilterBar(),

const SizedBox(height: 18),

_buildHistoryHeader(),

const SizedBox(height: 10),

...controller.history.map(
(item) => Padding(
padding: const EdgeInsets.only(
bottom: 12,
),
child: _buildAttendanceCard(item),
),
),

if (controller.isLoading.value &&
controller.history.isNotEmpty)
const Padding(
padding: EdgeInsets.symmetric(
vertical: 20,
),
child: Center(
child: CircularProgressIndicator(),
),
),

if (!controller.hasMore.value &&
controller.history.isNotEmpty)
Padding(
padding: const EdgeInsets.only(
top: 10,
bottom: 10,
),
child: Center(
child: Text(
'تم عرض جميع السجلات',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 13,
),
),
),
),
],
),
),
);
},
),
);
}

// ============================================================
// APP BAR
// ============================================================

PreferredSizeWidget _buildAppBar() {
return AppBar(
elevation: 0,
backgroundColor: Colors.white,
surfaceTintColor: Colors.white,
centerTitle: false,
title: const Text(
'سجل الحضور',
style: TextStyle(
color: Color(0xFF171A21),
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
actions: [
IconButton(
onPressed: () {
_showFilterSheet();
},
icon: const Icon(
Icons.tune_rounded,
color: AppColors.primary,
),
),
const SizedBox(width: 6),
],
);
}

// ============================================================
// SUMMARY
// ============================================================

Widget _buildSummaryCard() {
final present = controller.presentCount;
final absent = controller.absentCount;
final total = controller.history.length;

return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: AppColors.mainGradient,
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color: AppColors.primary.withOpacity(.20),
blurRadius: 20,
offset: const Offset(0, 8),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Row(
children: [
Icon(
Icons.fact_check_rounded,
color: Colors.white,
size: 25,
),
SizedBox(width: 10),
Text(
'ملخص الحضور',
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),

const SizedBox(height: 18),

Row(
children: [
Expanded(
child: _summaryItem(
title: 'الحاضرون',
value: '$present',
icon: Icons.check_circle_rounded,
),
),
const SizedBox(width: 10),
Expanded(
child: _summaryItem(
title: 'الغائبون',
value: '$absent',
icon: Icons.cancel_rounded,
),
),
const SizedBox(width: 10),
Expanded(
child: _summaryItem(
title: 'السجلات',
value: '$total',
icon: Icons.list_alt_rounded,
),
),
],
),
],
),
);
}

Widget _summaryItem({
required String title,
required String value,
required IconData icon,
}) {
return Container(
padding: const EdgeInsets.symmetric(
vertical: 13,
horizontal: 8,
),
decoration: BoxDecoration(
color: Colors.white.withOpacity(.14),
borderRadius: BorderRadius.circular(16),
),
child: Column(
children: [
Icon(
icon,
color: Colors.white,
size: 21,
),
const SizedBox(height: 7),
Text(
value,
style: const TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 3),
Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.white70,
fontSize: 11,
),
),
],
),
);
}

// ============================================================
// FILTER BAR
// ============================================================

Widget _buildFilterBar() {
final hasFilters =
controller.selectedType.value.isNotEmpty ||
controller.selectedStatus.value.isNotEmpty ||
controller.dateFrom.value.isNotEmpty ||
controller.dateTo.value.isNotEmpty;

return Row(
children: [
Expanded(
child: Container(
padding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 12,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(15),
border: Border.all(
color: Colors.grey.shade200,
),
),
child: Row(
children: [
Icon(
Icons.filter_alt_outlined,
size: 20,
color: AppColors.primary,
),
const SizedBox(width: 9),
Expanded(
child: Text(
_filterText(),
style: TextStyle(
color: hasFilters
? const Color(0xFF20242D)
    : Colors.grey.shade600,
fontWeight: FontWeight.w600,
fontSize: 13,
),
),
),
],
),
),
),

const SizedBox(width: 10),

InkWell(
onTap: _showFilterSheet,
borderRadius: BorderRadius.circular(15),
child: Container(
width: 48,
height: 48,
decoration: BoxDecoration(
color: AppColors.primary,
borderRadius: BorderRadius.circular(15),
),
child: const Icon(
Icons.tune_rounded,
color: Colors.white,
),
),
),
],
);
}

String _filterText() {
final parts = <String>[];

if (controller.selectedType.value.isNotEmpty) {
parts.add(
controller.selectedType.value == 'lecture'
? 'محاضرات'
    : 'سكن',
);
}

if (controller.selectedStatus.value.isNotEmpty) {
parts.add(
controller.selectedStatus.value == 'present'
? 'حاضر'
    : 'غائب',
);
}

if (parts.isEmpty) {
return 'جميع سجلات الحضور';
}

return parts.join(' • ');
}

// ============================================================
// HISTORY HEADER
// ============================================================

Widget _buildHistoryHeader() {
return Row(
children: [
const Expanded(
child: Text(
'السجلات',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Color(0xFF181B22),
),
),
),
Text(
'${controller.total.value} سجل',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 13,
),
),
],
);
}

// ============================================================
// ATTENDANCE CARD
// ============================================================

Widget _buildAttendanceCard(
AttendanceHistoryModel item,
) {
final bool isPresent =
item.status.toLowerCase() == 'present';

final bool isHousing =
item.shiftType.toLowerCase() == 'housing';

final student = item.student;
final shift = item.shift;
final details = item.shiftDetails;

return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
border: Border.all(
color: Colors.grey.shade200,
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.035),
blurRadius: 12,
offset: const Offset(0, 5),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// ------------------------------------------------------
// STUDENT
// ------------------------------------------------------

Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: AppColors.buttonGradient,
),
borderRadius: BorderRadius.circular(15),
),
child: const Icon(
Icons.person_rounded,
color: Colors.white,
size: 25,
),
),

const SizedBox(width: 12),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
student?.fullName ?? 'طالب غير معروف',
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Color(0xFF171A21),
fontSize: 16,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 4),

Text(
'الرقم الجامعي: ${student?.studentIdentifier ?? '-'}',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 12,
),
),
],
),
),

_statusBadge(isPresent),
],
),

const SizedBox(height: 15),

// ------------------------------------------------------
// TYPE
// ------------------------------------------------------

Row(
children: [
_smallTag(
icon: isHousing
? Icons.apartment_rounded
    : Icons.school_rounded,
text: isHousing ? 'سكن' : 'محاضرة',
),

if (details?.isPractical == true) ...[
const SizedBox(width: 7),
_smallTag(
icon: Icons.science_rounded,
text: 'عملي',
),
],

if (details?.isPractical == false &&
!isHousing) ...[
const SizedBox(width: 7),
_smallTag(
icon: Icons.menu_book_rounded,
text: 'نظري',
),
],
],
),

const SizedBox(height: 14),

// ------------------------------------------------------
// LECTURE DETAILS
// ------------------------------------------------------

if (!isHousing)
_buildLectureDetails(
item,
details,
),

// ------------------------------------------------------
// HOUSING DETAILS
// ------------------------------------------------------

if (isHousing)
_buildHousingDetails(
item,
details,
),

const SizedBox(height: 14),

// ------------------------------------------------------
// SHIFT INFO
// ------------------------------------------------------

if (shift != null)
_buildShiftInfo(
item,
),

const SizedBox(height: 12),

// ------------------------------------------------------
// ATTENDANCE TIME
// ------------------------------------------------------

_buildAttendanceTime(item),
],
),
);
}

// ============================================================
// STATUS
// ============================================================

Widget _statusBadge(bool isPresent) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 7,
),
decoration: BoxDecoration(
color: isPresent
? Colors.green.withOpacity(.10)
    : Colors.red.withOpacity(.10),
borderRadius: BorderRadius.circular(12),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
isPresent
? Icons.check_circle_rounded
    : Icons.cancel_rounded,
size: 16,
color: isPresent
? Colors.green.shade700
    : Colors.red.shade700,
),
const SizedBox(width: 5),
Text(
isPresent ? 'حاضر' : 'غائب',
style: TextStyle(
color: isPresent
? Colors.green.shade700
    : Colors.red.shade700,
fontSize: 12,
fontWeight: FontWeight.bold,
),
),
],
),
);
}

// ============================================================
// LECTURE DETAILS
// ============================================================

Widget _buildLectureDetails(
AttendanceHistoryModel item,
dynamic details,
) {
return Column(
children: [
if (details?.subjectName != null &&
details.subjectName.toString().isNotEmpty)
_infoRow(
Icons.menu_book_rounded,
'المادة',
details.subjectName.toString(),
),

if (details?.teacherName != null &&
details.teacherName.toString().isNotEmpty)
_infoRow(
Icons.person_outline_rounded,
'المدرس',
details.teacherName.toString(),
),

if (details?.location != null &&
details.location.toString().isNotEmpty)
_infoRow(
Icons.location_on_outlined,
'المكان',
details.location.toString(),
),

if (details?.year != null)
_infoRow(
Icons.school_outlined,
'السنة',
details.year.toString(),
),

if (details?.specialization != null &&
details.specialization
    .toString()
    .isNotEmpty)
_infoRow(
Icons.category_outlined,
'الاختصاص',
details.specialization.toString(),
),

if (details?.branch != null &&
details.branch.toString().isNotEmpty)
_infoRow(
Icons.account_tree_outlined,
'الشعبة',
details.branch.toString(),
),
],
);
}

// ============================================================
// HOUSING DETAILS
// ============================================================

Widget _buildHousingDetails(
AttendanceHistoryModel item,
dynamic details,
) {
final room = details?.room;

return Column(
children: [
if (details?.dormitoryName != null &&
details.dormitoryName
    .toString()
    .isNotEmpty)
_infoRow(
Icons.apartment_rounded,
'السكن',
details.dormitoryName.toString(),
),

if (room != null)
_infoRow(
Icons.meeting_room_outlined,
'الغرفة',
room.roomNumber?.toString() ?? '-',
),
],
);
}

// ============================================================
// SHIFT INFO
// ============================================================

Widget _buildShiftInfo(
AttendanceHistoryModel item,
) {
final shift = item.shift;

if (shift == null) {
return const SizedBox.shrink();
}

return Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: const Color(0xFFF7F8FA),
borderRadius: BorderRadius.circular(15),
),
child: Row(
children: [
const Icon(
Icons.calendar_month_rounded,
size: 19,
color: AppColors.primary,
),

const SizedBox(width: 9),

Expanded(
child: Text(
'${shift.shiftDate} • ${shift.day}',
style: const TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
),

const Icon(
Icons.access_time_rounded,
size: 18,
color: AppColors.primary,
),

const SizedBox(width: 5),

Text(
'${_formatTime(shift.fromHour)} - ${_formatTime(shift.toHour)}',
style: const TextStyle(
fontSize: 11,
fontWeight: FontWeight.w600,
),
),
],
),
);
}

// ============================================================
// ATTENDANCE TIME
// ============================================================

Widget _buildAttendanceTime(
AttendanceHistoryModel item,
) {
final bool isPresent =
item.status.toLowerCase() == 'present';

return Row(
children: [
Icon(
isPresent
? Icons.login_rounded
    : Icons.event_busy_rounded,
size: 18,
color: isPresent
? Colors.green.shade700
    : Colors.red.shade700,
),

const SizedBox(width: 7),

Expanded(
child: Text(
isPresent
? 'وقت الحضور: ${_formatDateTime(item.checkInAt)}'
    : 'لم يتم تسجيل حضور الطالب',
style: TextStyle(
color: isPresent
? Colors.green.shade700
    : Colors.red.shade700,
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
),
],
);
}

// ============================================================
// INFO ROW
// ============================================================

Widget _infoRow(
IconData icon,
String title,
String value,
) {
return Padding(
padding: const EdgeInsets.only(
bottom: 9,
),
child: Row(
children: [
Icon(
icon,
size: 18,
color: AppColors.primary,
),

const SizedBox(width: 9),

Text(
'$title:',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 12,
),
),

const SizedBox(width: 6),

Expanded(
child: Text(
value,
textAlign: TextAlign.end,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Color(0xFF20242D),
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
),
],
),
);
}

// ============================================================
// SMALL TAG
// ============================================================

Widget _smallTag({
required IconData icon,
required String text,
}) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 9,
vertical: 6,
),
decoration: BoxDecoration(
color: AppColors.primary.withOpacity(.08),
borderRadius: BorderRadius.circular(10),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
icon,
size: 14,
color: AppColors.primary,
),
const SizedBox(width: 5),
Text(
text,
style: const TextStyle(
color: AppColors.primary,
fontSize: 11,
fontWeight: FontWeight.w600,
),
),
],
),
);
}

// ============================================================
// FILTER SHEET
// ============================================================

void _showFilterSheet() {
Get.bottomSheet(
SafeArea(
child: Container(
padding: const EdgeInsets.fromLTRB(
20,
12,
20,
25,
),
decoration: const BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.vertical(
top: Radius.circular(28),
),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 42,
height: 4,
decoration: BoxDecoration(
color: Colors.grey.shade300,
borderRadius: BorderRadius.circular(20),
),
),

const SizedBox(height: 20),

const Align(
alignment: Alignment.centerRight,
child: Text(
'فلترة سجل الحضور',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 20),

_filterSectionTitle('نوع الحضور'),

const SizedBox(height: 10),

Obx(
() => Row(
children: [
Expanded(
child: _filterChoice(
title: 'الكل',
selected:
controller.selectedType.value.isEmpty,
onTap: () {
controller.selectedType.value = '';
},
),
),
const SizedBox(width: 8),
Expanded(
child: _filterChoice(
title: 'محاضرات',
selected:
controller.selectedType.value ==
'lecture',
onTap: () {
controller.selectedType.value =
'lecture';
},
),
),
const SizedBox(width: 8),
Expanded(
child: _filterChoice(
title: 'سكن',
selected:
controller.selectedType.value ==
'housing',
onTap: () {
controller.selectedType.value =
'housing';
},
),
),
],
),
),

const SizedBox(height: 20),

_filterSectionTitle('حالة الحضور'),

const SizedBox(height: 10),

Obx(
() => Row(
children: [
Expanded(
child: _filterChoice(
title: 'الكل',
selected:
controller.selectedStatus.value.isEmpty,
onTap: () {
controller.selectedStatus.value = '';
},
),
),
const SizedBox(width: 8),
Expanded(
child: _filterChoice(
title: 'حاضر',
selected:
controller.selectedStatus.value ==
'present',
onTap: () {
controller.selectedStatus.value =
'present';
},
),
),
const SizedBox(width: 8),
Expanded(
child: _filterChoice(
title: 'غائب',
selected:
controller.selectedStatus.value ==
'absent',
onTap: () {
controller.selectedStatus.value =
'absent';
},
),
),
],
),
),

const SizedBox(height: 20),

_filterSectionTitle('التاريخ'),

const SizedBox(height: 10),

Obx(
() => Row(
children: [
Expanded(
child: _dateButton(
title: controller.dateFrom.value.isEmpty
? 'من تاريخ'
    : controller.dateFrom.value,
onTap: () {
_pickDate(
isFrom: true,
);
},
),
),

const SizedBox(width: 10),

Expanded(
child: _dateButton(
title: controller.dateTo.value.isEmpty
? 'إلى تاريخ'
    : controller.dateTo.value,
onTap: () {
_pickDate(
isFrom: false,
);
},
),
),
],
),
),

const SizedBox(height: 24),

Row(
children: [
Expanded(
child: OutlinedButton(
onPressed: () async {
await controller.clearFilters();
Get.back();
},
style: OutlinedButton.styleFrom(
minimumSize:
const Size.fromHeight(52),
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),
child: const Text(
'مسح الفلاتر',
),
),
),

const SizedBox(width: 10),

Expanded(
child: ElevatedButton(
onPressed: () async {
await controller.loadHistory(
refresh: true,
);

Get.back();
},
style: ElevatedButton.styleFrom(
backgroundColor:
AppColors.primary,
foregroundColor: Colors.white,
minimumSize:
const Size.fromHeight(52),
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),
child: const Text(
'تطبيق',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
),
],
),
],
),
),
),
isScrollControlled: true,
);
}

// ============================================================
// FILTER TITLE
// ============================================================

Widget _filterSectionTitle(String title) {
return Align(
alignment: Alignment.centerRight,
child: Text(
title,
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
color: Color(0xFF20242D),
),
),
);
}

// ============================================================
// FILTER CHOICE
// ============================================================

Widget _filterChoice({
required String title,
required bool selected,
required VoidCallback onTap,
}) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(14),
child: AnimatedContainer(
duration: const Duration(
milliseconds: 180,
),
height: 46,
decoration: BoxDecoration(
color: selected
? AppColors.primary
    : const Color(0xFFF5F6F8),
borderRadius: BorderRadius.circular(14),
border: Border.all(
color: selected
? AppColors.primary
    : Colors.grey.shade200,
),
),
child: Center(
child: Text(
title,
style: TextStyle(
color: selected
? Colors.white
    : const Color(0xFF555A64),
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
),
),
);
}

// ============================================================
// DATE BUTTON
// ============================================================

Widget _dateButton({
required String title,
required VoidCallback onTap,
}) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(14),
child: Container(
height: 48,
padding: const EdgeInsets.symmetric(
horizontal: 12,
),
decoration: BoxDecoration(
color: const Color(0xFFF5F6F8),
borderRadius: BorderRadius.circular(14),
border: Border.all(
color: Colors.grey.shade200,
),
),
child: Row(
children: [
const Icon(
Icons.calendar_today_rounded,
size: 17,
color: AppColors.primary,
),
const SizedBox(width: 8),
Expanded(
child: Text(
title,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
),
),
),
],
),
),
);
}

// ============================================================
// DATE PICKER
// ============================================================

Future<void> _pickDate({
required bool isFrom,
}) async {
DateTime? initialDate;

final currentValue = isFrom
? controller.dateFrom.value
    : controller.dateTo.value;

if (currentValue.isNotEmpty) {
initialDate = DateTime.tryParse(
currentValue,
);
}

final selected = await showDatePicker(
context: context,
initialDate: initialDate ?? DateTime.now(),
firstDate: DateTime(2020),
lastDate: DateTime(2035),
);

if (selected == null) {
return;
}

final formatted =
'${selected.year.toString().padLeft(4, '0')}-'
'${selected.month.toString().padLeft(2, '0')}-'
'${selected.day.toString().padLeft(2, '0')}';

if (isFrom) {
controller.dateFrom.value = formatted;
} else {
controller.dateTo.value = formatted;
}
}

// ============================================================
// ERROR
// ============================================================

Widget _buildErrorState() {
return Center(
child: Padding(
padding: const EdgeInsets.all(25),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.error_outline_rounded,
size: 65,
color: Colors.red.shade300,
),

const SizedBox(height: 15),

const Text(
'حدث خطأ أثناء تحميل سجل الحضور',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
controller.errorMessage.value,
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 13,
),
),

const SizedBox(height: 20),

ElevatedButton(
onPressed: () {
controller.refreshHistory();
},
child: const Text(
'إعادة المحاولة',
),
),
],
),
),
);
}

// ============================================================
// EMPTY
// ============================================================

Widget _buildEmptyState() {
return RefreshIndicator(
onRefresh: controller.refreshHistory,
child: ListView(
physics: const AlwaysScrollableScrollPhysics(),
children: [
SizedBox(
height: MediaQuery.of(context).size.height * .30,
),

Icon(
Icons.event_busy_rounded,
size: 75,
color: Colors.grey.shade300,
),

const SizedBox(height: 18),

const Center(
child: Text(
'لا توجد سجلات حضور',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(height: 8),

Center(
child: Text(
'لم يتم العثور على سجلات حسب الفلاتر الحالية',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 13,
),
),
),
],
),
);
}

// ============================================================
// FORMAT DATE TIME
// ============================================================

String _formatDateTime(String? value) {
if (value == null || value.isEmpty) {
return '-';
}

return value;
}

// ============================================================
// FORMAT TIME
// ============================================================

String _formatTime(String? value) {
if (value == null || value.isEmpty) {
return '-';
}

if (value.length >= 5) {
return value.substring(0, 5);
}

return value;
}
}

