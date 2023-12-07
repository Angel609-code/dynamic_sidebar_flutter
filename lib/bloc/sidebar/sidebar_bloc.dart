import 'package:dynamic_sidebar/bloc/sidebar/sidebar_event.dart';
import 'package:dynamic_sidebar/bloc/sidebar/sidebar_state.dart';
import 'package:dynamic_sidebar/models/menu_model.dart';
import 'package:dynamic_sidebar/postgress/db_methods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  SidebarBloc() : super(SidebarInitial()) {
    on<FetchMenuData>((event, emit) async {
      emit(SidebarLoading());
      try {
        List<MenuModel> data = await fetchMenuData('admin', '%%');
        if (data.isNotEmpty) {
          emit(SidebarLoaded(data));
        } else {
          emit(SidebarNoData());
        }
      } catch (error) {
        emit(SidebarError(error.toString()));
      }
    });

    on<UpdateTreeEvent>((event, emit) async {
      emit(SidebarLoading());
      try {
        List<MenuModel> data = await fetchMenuData('admin', '%${event.searchTerm}%');
        emit(SidebarLoaded(data));
      } catch (error) {
        emit(SidebarError(error.toString()));
      }
    });
  }
}