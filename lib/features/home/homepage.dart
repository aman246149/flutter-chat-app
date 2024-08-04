import 'package:brandzone/core/bloc/auth/auth_bloc.dart';
import 'package:brandzone/core/bloc/chat/chat_cubit.dart';
import 'package:brandzone/core/presentation/widgets/appbar.dart';
import 'package:brandzone/core/utils/common_methods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/user/user_cubit.dart';
import '../auth/export.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUser();
    context.read<UserCubit>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarN(
        text: "All Users",
        isBackButtonRequired: false,
        actions: [
          IconButton(
            onPressed: () {
              context.router.replace(const LoginRoute());
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is chatLoading) {
            showOverlayLoader(context);
          } else if (state is CreateGroupSuccess) {
            hideOverlayLoader(context);
            context.router.push(const ChatPage());
          } else if (state is chatError) {
            hideOverlayLoader(context);
            showErrorSnackbar(context, state.message);
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetAllUsersSuccessState) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return GestureDetector(
                    onTap: () {
                      context.read<ChatCubit>().createGroup({
                        "groupId": context.read<ChatCubit>().generateGroupID(
                              context.read<UserCubit>().user?.sub ?? "",
                              user.sub ?? "",
                              context.read<UserCubit>().user?.name ?? "",
                              user.name ?? "",
                            ),
                      });
                    },
                    child: ListTile(
                      title: Text(user.name ?? ""),
                      subtitle: Text(user.email ?? ""),
                    ),
                  );
                },
              );
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
