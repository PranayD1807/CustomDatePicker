// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key,
      required this.initialDate,
      this.startYear,
      this.endYear,
      required this.cancel,
      required this.ok,
      required this.widgetWidth,
      this.activeColor,
      this.focusColor,
      this.hoverColor,
      this.splashColor,
      this.highlightColor,
      this.unselectedForegroundColor,
      this.selectedForegroundColor,
      this.unselectedBackgroundColor,
      this.selectedBackgroundColor});
  final DateTime initialDate;
  final DateTime? startYear;
  final DateTime? endYear;
  final Function cancel;
  final Function(DateTime? returnedDate) ok;
  final double widgetWidth;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? unselectedForegroundColor;
  final Color? selectedForegroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBackgroundColor;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  List<DateTime> months = [
    DateTime(2000, 1),
    DateTime(2000, 2),
    DateTime(2000, 3),
    DateTime(2000, 4),
    DateTime(2000, 5),
    DateTime(2000, 6),
    DateTime(2000, 7),
    DateTime(2000, 8),
    DateTime(2000, 9),
    DateTime(2000, 10),
    DateTime(2000, 11),
    DateTime(2000, 12),
  ];

  int selectedMonth = 0;
  int selectedYear = 2000;
  int? selectedDay;
  int startYear = 1900;
  int endYear = 2100;
  DateTime? iCDate; // First Date to be shown
  DateTime? eCDate; // Last Date to be shown

  int day = 0;
  List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  double? widgetWidth;
  bool monthSelectorActive = false;
  bool yearSelectorActive = false;
  bool daySelectorActive = true;

  // ScrollController monthScrollController = ScrollController();
  // ScrollController yearScrollController = ScrollController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    selectedMonth =
        widget.initialDate.month - 1; // because our list starts from index 0
    selectedDay = widget.initialDate.day;
    selectedYear = widget.initialDate.year;
    if (widget.startYear != null) startYear = widget.startYear!.year;
    if (widget.endYear != null) startYear = widget.endYear!.year;
  }

  void selectYear({bool increment = false, bool decrement = false}) {
    setState(() {
      if (decrement) {
        if (selectedYear == startYear) return;
        selectedYear--;
        selectedDay = null;
      } else if (increment) {
        if (selectedYear == endYear) return;
        selectedYear++;
        selectedDay = null;
      }
    });
  }

  void selectMonth({bool increment = false, bool decrement = false}) {
    setState(() {
      if (decrement) {
        if (selectedMonth == 0) return;
        selectedMonth--;
        selectedDay = null;
      } else if (increment) {
        if (selectedMonth == 11) return;
        selectedMonth++;
        selectedDay = null;
      }
    });
  }

  Widget customSelector({bool isYear = false, bool isMonth = false}) {
    return SizedBox(
      width: widgetWidth! * 0.4,
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: daySelectorActive
                  ? widget.activeColor ?? Colors.black
                  : Colors.transparent,
              focusColor: widget.focusColor ?? Colors.transparent,
              hoverColor: widget.hoverColor ?? Colors.transparent,
              splashColor: widget.splashColor ?? Colors.transparent,
              highlightColor: widget.highlightColor ?? Colors.transparent,
              constraints: const BoxConstraints(),
              onPressed: () {
                if (!daySelectorActive) return;
                if (isYear) {
                  selectYear(decrement: true);
                } else if (isMonth) {
                  selectMonth(decrement: true);
                }
              },
              icon: Icon(
                Icons.chevron_left,
                color: widget.unselectedForegroundColor ?? Colors.black,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor:
                      widget.unselectedForegroundColor ?? Colors.black),
              onPressed: () {
                if (isYear) {
                  if (scrollController.hasClients) {
                    scrollController.jumpTo(
                      ((selectedYear - startYear - 2) * 50),
                    );
                  }
                  setState(() {
                    yearSelectorActive = true;
                    monthSelectorActive = false;
                    daySelectorActive = false;
                  });
                } else if (isMonth) {
                  if (scrollController.hasClients) {
                    scrollController.jumpTo(
                      (selectedMonth < 2 ? 0 : selectedMonth - 2) * 50,
                    );
                  }
                  setState(() {
                    monthSelectorActive = true;
                    yearSelectorActive = false;
                    daySelectorActive = false;
                  });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isYear
                        ? '$selectedYear'
                        : DateFormat('MMM').format(months[selectedMonth]),
                    style: TextStyle(
                      color: widget.unselectedForegroundColor ?? Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.unselectedForegroundColor ?? Colors.black,
                  ),
                ],
              ),
            ),
            IconButton(
              color: daySelectorActive
                  ? widget.activeColor ?? Colors.black
                  : Colors.transparent,
              focusColor: widget.focusColor ?? Colors.transparent,
              hoverColor: widget.hoverColor ?? Colors.transparent,
              splashColor: widget.splashColor ?? Colors.transparent,
              highlightColor: widget.highlightColor ?? Colors.transparent,
              constraints: const BoxConstraints(),
              onPressed: () {
                if (!daySelectorActive) return;

                if (isYear) {
                  selectYear(increment: true);
                } else if (isMonth) {
                  selectMonth(increment: true);
                }
              },
              icon: Icon(
                Icons.chevron_right,
                color: widget.unselectedForegroundColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGridDelegate delegate = const SliverGridDelegateWithFixedCrossAxisCount(
    childAspectRatio: 1,
    crossAxisCount: 7,
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
  );

  @override
  Widget build(BuildContext context) {
    widgetWidth = widget.widgetWidth; // set widget width

    DateTime firstOfMonth = DateTime(selectedYear, selectedMonth + 1,
        1); // selectedMonth + 1  points to current month
    DateTime lastDateOfMonth = DateTime(selectedYear, selectedMonth + 2, 0); //

    // we find the weekDay of 1st of month
    int day = firstOfMonth.weekday % 7; // 7 = sunday
    iCDate = firstOfMonth.subtract(Duration(days: day));

    int daysInMonth = DateTimeRange(start: firstOfMonth, end: lastDateOfMonth)
            .duration
            .inDays +
        1; // Total Days in Month

    int dayOfLastDate = lastDateOfMonth.weekday % 7;
    int itemCount = day + daysInMonth + (6 - dayOfLastDate);

    return SizedBox(
      width: widgetWidth,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customSelector(isMonth: true),
                customSelector(isYear: true),
              ],
            ),
            if (daySelectorActive)
              DaySelector(itemCount, firstOfMonth, lastDateOfMonth),
            if (monthSelectorActive) MonthSelector(),
            if (yearSelectorActive) YearSelector(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Year Selector
  Column YearSelector() {
    Widget YearTile(int index) {
      return InkWell(
        onTap: () {
          setState(() {
            selectedYear = index + startYear;
            yearSelectorActive = false;
            daySelectorActive = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: selectedYear == index + startYear
                  ? const Color.fromRGBO(28, 28, 28, 0.06)
                  : Colors.transparent),
          height: 50,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const SizedBox(width: 15),
              selectedYear == index + startYear
                  ? Icon(
                      Icons.check,
                      color: widget.selectedForegroundColor ?? Colors.black,
                      size: 30,
                    )
                  : const SizedBox(
                      width: 30,
                    ),
              const SizedBox(width: 30),
              Text(
                "${index + startYear}",
                style: const TextStyle(fontSize: kIsWeb ? null : 16),
              ),
            ],
          ),
        ),
      );
    }

    scrollController = ScrollController(
      initialScrollOffset:
          ((selectedYear - startYear - 2) * 50), // -2 to set scroll in middle
    );
    /*
    yearScrollController = ScrollController(
      initialScrollOffset:
          ((selectedYear - startYear - 2) * 50), // -2 to set scroll in middle
    );
*/
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        SizedBox(
          height: 250,
          child: ListView.builder(
            // controller: yearScrollController,
            controller: scrollController,
            shrinkWrap: true,
            itemCount: endYear - startYear + 1,
            itemBuilder: (context, index) {
              return YearTile(index);
            },
          ),
        )
      ],
    );
  }

  /// Month Selector
  Column MonthSelector() {
    Widget MonthTile(int index) {
      return InkWell(
        onTap: () {
          setState(() {
            selectedMonth = index;
            monthSelectorActive = false;
            daySelectorActive = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: selectedMonth == index
                  ? const Color.fromRGBO(28, 28, 28, 0.06)
                  : Colors.transparent),
          height: 50,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const SizedBox(width: 15),
              selectedMonth == index
                  ? Icon(
                      Icons.check,
                      color: widget.selectedForegroundColor ?? Colors.black,
                      size: 30,
                    )
                  : const SizedBox(
                      width: 30,
                    ),
              const SizedBox(width: 30),
              Text(
                DateFormat("MMMM").format(months[index]),
                style: const TextStyle(fontSize: kIsWeb ? null : 16),
              ),
            ],
          ),
        ),
      );
    }

    scrollController = ScrollController(
      initialScrollOffset: (selectedMonth < 2 ? 0 : selectedMonth - 2) * 50,
    );
    /*
    monthScrollController = ScrollController(
      initialScrollOffset: (selectedMonth < 2 ? 0 : selectedMonth - 2) * 50,
    );*/

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        SizedBox(
          height: 250,
          child: ListView.builder(
            // controller: monthScrollController,
            controller: scrollController,
            shrinkWrap: true,
            itemCount: months.length,
            itemBuilder: (context, index) {
              return MonthTile(index);
            },
          ),
        )
      ],
    );
  }

  Column DaySelector(
      int itemCount, DateTime firstOfMonth, DateTime lastDateOfMonth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: delegate,
            itemCount: 7,
            itemBuilder: (context, index) {
              return FittedBox(
                child: CircleAvatar(
                  backgroundColor:
                      widget.unselectedBackgroundColor ?? Colors.white,
                  foregroundColor:
                      widget.unselectedForegroundColor ?? Colors.black,
                  child: Center(
                    child: Text(
                      days[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        //dates
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: delegate,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              DateTime iDate = iCDate!.add(Duration(days: index));

              Color fgColor;
              if (iDate.isBefore(firstOfMonth) ||
                  iDate.isAfter(lastDateOfMonth)) {
                fgColor = const Color.fromRGBO(104, 104, 104, 0.7);
              } else if (selectedDay == iDate.day) {
                fgColor = widget.selectedForegroundColor ?? Colors.white;
              } else {
                fgColor = widget.unselectedForegroundColor ?? Colors.black;
              }

              Color bgColor = Colors.white;
              // If date is within current Month and selected then set its bgColor to black
              if ((!iDate.isBefore(firstOfMonth) &&
                      !iDate.isAfter(lastDateOfMonth)) &&
                  selectedDay == iDate.day) {
                bgColor = widget.selectedBackgroundColor ?? Colors.black;
              }

              return FittedBox(
                child: InkWell(
                  splashColor: widget.splashColor ?? Colors.transparent,
                  focusColor: widget.focusColor ?? Colors.transparent,
                  highlightColor: widget.highlightColor ?? Colors.transparent,
                  hoverColor: widget.hoverColor ?? Colors.transparent,
                  onTap: () {
                    if (iDate.isBefore(firstOfMonth) ||
                        iDate.isAfter(lastDateOfMonth)) return;

                    setState(() {
                      selectedDay = iDate.day;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: bgColor,
                    foregroundColor: fgColor,
                    child: Text(
                      iDate.day.toString(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: widgetWidth! * 0.2,
                child: FittedBox(
                  child: TextButton(
                    onPressed: () {
                      widget.cancel();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.unselectedForegroundColor ?? Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: widgetWidth! * 0.2,
                child: FittedBox(
                  child: TextButton(
                    onPressed: () {
                      if (selectedDay == null) return;
                      // SelectedMonth is index of array of months ( which start from 0 ) , hence add 1 to get actual month
                      widget.ok(
                        DateTime(selectedYear, selectedMonth + 1, selectedDay!),
                      );
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.unselectedForegroundColor ?? Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
