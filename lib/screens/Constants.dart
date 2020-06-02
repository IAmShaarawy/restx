import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String TABLE_NUMBER = "table_number";

// routes
const String ROUTE_MENU = '/menu';
const String ROUTE_AUTH = '/auth';
const String ROUTE_QR = '/qr';
const String ROUTE_WAITER_HOME = '/waiter';
const String ROUTE_TABLE_ORDER = '/waiter/table';
const String ROUTE_USER_HOME = 'user';

const UNDER_SELECTION = "under_selection";
const UNDER_PICK = "under_pick";
const UNDER_PREPARATION = "under_preparation";
const SERVED = "served";
const WAITING_CHECK_OUT = "waiting_check_out";
const CHECKED_OUT = "checked_out";
