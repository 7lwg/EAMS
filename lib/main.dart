import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/Circular_indicator_cubit/circular_indicator_cubit.dart';
import 'package:graduation_project/Cubits/Adding%20Users%20To%20Department%20Or%20Shift/adding_users_to_department_or_shift_cubit.dart';
import 'package:graduation_project/Cubits/Attendance_data/attendance_data_cubit.dart';
import 'package:graduation_project/Cubits/Companies%20name/companies_name_cubit.dart';
import 'package:graduation_project/Cubits/Departments_Data/departments_data_cubit.dart';
import 'package:graduation_project/Cubits/Search/search_cubit.dart';
import 'package:graduation_project/Cubits/Shifts_data/shifts_data_cubit.dart';
import 'package:graduation_project/Cubits/Show%20password/show_password_cubit.dart';
import 'package:graduation_project/Cubits/Show_field_requirments/field_requirments_cubit.dart';
import 'package:graduation_project/Cubits/Users_data/users_data_cubit.dart';
import 'package:graduation_project/Cubits/attendance%20new_data/attendance_new_data_cubit.dart';
import 'package:graduation_project/Cubits/bloc_obsrever.dart';
import 'package:graduation_project/Cubits/notifications/notifications_cubit.dart';
import 'package:graduation_project/Screen/Splash_Screen.dart';
// import 'package:graduation_project/Screen/employeer%20screens/attendance_screen.dart';
import 'package:graduation_project/data/Repository/cach_helper.dart';
import 'package:graduation_project/data/Repository/dio_helper.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:graduation_project/Screen/test.dart';
// import 'package:graduation_project/test2.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final landscape = mediaQuery.orientation == Orientation.landscape;
    return MultiBlocProvider(
      providers: [
        BlocProvider<CircularIndicatorCubit>(
          create: (BuildContext context) => CircularIndicatorCubit(),
        ),
        BlocProvider<ShowPasswordCubit>(
          create: (BuildContext context) => ShowPasswordCubit(),
        ),
        BlocProvider<UsersDataCubit>(
          create: (BuildContext context) => UsersDataCubit(),
        ),
        BlocProvider<SearchCubit>(
          create: (BuildContext context) => SearchCubit(),
        ),
        BlocProvider<FieldRequirmentsCubit>(
          create: (BuildContext context) => FieldRequirmentsCubit(),
        ),
        BlocProvider<DepartmentsDataCubit>(
          create: (BuildContext context) => DepartmentsDataCubit(),
        ),
        BlocProvider<ShiftsDataCubit>(
          create: (BuildContext context) => ShiftsDataCubit(),
        ),
        BlocProvider<AttendanceDataCubit>(
          create: (BuildContext context) => AttendanceDataCubit(),
        ),
        BlocProvider<AddingUsersToDepartmentOrShiftCubit>(
          create: (BuildContext context) =>
              AddingUsersToDepartmentOrShiftCubit(),
        ),
        BlocProvider<CompaniesNameCubit>(
          create: (BuildContext context) => CompaniesNameCubit(),
        ),
        BlocProvider<AttendanceNewDataCubit>(
          create: (BuildContext context) => AttendanceNewDataCubit(),
        ),
        BlocProvider<NotificationsCubit>(
          create: (BuildContext context) => NotificationsCubit(),
        ),
      ],
      child: MaterialApp(
        // builder: (context,Widget) => ResponsiveWra,
        title: 'Flutter Demo',
        // theme: ThemeData(
        //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //     useMaterial3: true,
        //     sliderTheme: SliderThemeData(
        //       rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
        //       overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
        //       trackHeight: 4.0,
        //     )),
        builder: (context, Widget) => ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, Widget!),
            breakpoints: [
              ResponsiveBreakpoint.resize(350, name: MOBILE),
              ResponsiveBreakpoint.autoScale(600, name: TABLET),
              ResponsiveBreakpoint.resize(800, name: DESKTOP),
              ResponsiveBreakpoint.resize(1200, name: 'XL'),
            ]),
        // home: EmployeeList(),
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            trackHeight: 4.0,
          ),
          appBarTheme: AppBarTheme(
            // toolbarHeight: (landscape)
            //     ? mediaQuery.size.height * (100 / 800)
            //     : mediaQuery.size.height * (70 / 800),
            backgroundColor: HexColor('#3232A0'),
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        home: SplashScreen(),
        // home:AttendanceScreen(),
        // home: OnBoardingScreen(),
        // home: test2(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
