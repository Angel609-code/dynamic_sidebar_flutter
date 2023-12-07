import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dynamic_sidebar/bloc/sidebar/sidebar_bloc.dart';
import 'package:dynamic_sidebar/bloc/sidebar/sidebar_event.dart';
import 'package:dynamic_sidebar/bloc/sidebar/sidebar_state.dart';
import 'package:dynamic_sidebar/models/menu_model.dart';
import 'package:dynamic_sidebar/models/menu_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late TreeViewController _controller;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void updateTree(BuildContext context, searchTerm) {
    context.read<SidebarBloc>().add(UpdateTreeEvent(searchTerm));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SidebarBloc()..add(FetchMenuData()),
      child: BlocBuilder<SidebarBloc, SidebarState>(
        builder: (__, state) {
          if (state is SidebarLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SidebarError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
              ),
            );
          } else if (state is SidebarLoaded && state.menuData.isNotEmpty) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView(
                  children: [
                    const Text('Search'),
                    TextFormField(
                      controller:
                          _searchController, // Use the TextEditingController
                      onFieldSubmitted: (value) {
                        if(value.isNotEmpty) {
                          updateTree(context, value);
                        }
                      },
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight * 0.8,
                      child: TreeView.simple<MenuModel>(
                        tree: buildMenuTree(state.menuData,
                            _searchController.text.isEmpty, ''),
                        showRootNode: false,
                        expansionBehavior:
                            ExpansionBehavior.collapseOthersAndSnapToTop,
                        indentation: const Indentation(width: 0),
                        expansionIndicatorBuilder: (context, node) {
                          return ChevronIndicator.rightDown(
                            alignment: Alignment.centerRight,
                            tree: node,
                            color: Colors.black,
                            icon: Icons.arrow_right,
                          );
                        },
                        onItemTap: (item) {
                          if (item.data!.url != '/') {}
                        },
                        onTreeReady: (controller) {
                          _controller = controller;
                        },
                        builder: (context, node) {
                          final isExpanded = node.isExpanded;

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              color: node.level >= 2 || isExpanded
                                  ? Colors.lightGreen
                                  : Colors.blueAccent,
                              height: 42,
                              // Padding between one menu and another.
                              width: constraints.maxWidth,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: node.level == 2
                                    ? const EdgeInsets.only(left: 30)
                                    : node.level == 3
                                        ? const EdgeInsets.only(left: 35)
                                        : node.level >= 4
                                            ? const EdgeInsets.only(left: 40)
                                            : const EdgeInsets.only(left: 0),
                                child: Container(
                                  width: constraints.maxWidth,
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  decoration: const BoxDecoration(
                                      color: Colors.amber),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: node.level >= 2
                                        ? Text(
                                            node.data!.nombre,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              node.data!.menuId == 0
                                                  ? const Icon(
                                                      Icons.pages,
                                                      size: 20,
                                                      color: Colors.black,
                                                    )
                                                  : Container(),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  node.data!.nombre,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text('No Data Found'),
            );
          }
        },
      ),
    );
  }
}
