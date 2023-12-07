abstract class SidebarEvent {}

class FetchMenuData extends SidebarEvent {}

class UpdateTreeEvent extends SidebarEvent {
  final String searchTerm;

  UpdateTreeEvent(this.searchTerm);
}