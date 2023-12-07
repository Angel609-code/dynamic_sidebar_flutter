import 'package:dynamic_sidebar/models/menu_model.dart';

abstract class SidebarState {}

class SidebarInitial extends SidebarState {}

class SidebarLoading extends SidebarState {}

class SidebarLoaded extends SidebarState {
  final List<MenuModel> menuData;

  SidebarLoaded(this.menuData);
}

class SidebarError extends SidebarState {
  final String message;

  SidebarError(this.message);
}

class SidebarNoData extends SidebarState {}