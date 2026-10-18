import 'package:DReader/state/UserInfoState.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SetProxy extends ConsumerStatefulWidget {
  const SetProxy({super.key});

  @override
  ConsumerState<SetProxy> createState() => SetProxyState();
}

class SetProxyState extends ConsumerState<SetProxy> {
  bool enable = false;
  String host = '';
  int? port;

  @override
  void initState() {
    super.initState();

    final user = ref.read(userInfoStateProvider);
    enable = user?.proxyEnabled == 1;
    host = (user?.proxyHost ?? '').replaceFirst(RegExp(r'^https?://'), '');
    port = user?.proxyPort;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Row(
        children: [
          Text('代理设置'),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('启用代理'),
                subtitle: Text(
                  enable ? '已启用网络代理' : '直接连接网络',
                  style: theme.textTheme.bodySmall,
                ),
                value: enable,
                onChanged: (value) {
                  setState(() => enable = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: host,
                enabled: enable,
                decoration: const InputDecoration(
                  labelText: '代理地址',
                  hintText: '例如 192.168.1.100',
                  prefixIcon: Icon(Icons.dns_outlined),
                  prefixText: 'http://',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (enable && (value == null || value
                      .trim()
                      .isEmpty))
                    return '请输入代理地址';
                  return null;
                },
                onSaved: (value) => host = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: port?.toString() ?? '',
                enabled: enable,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '代理端口',
                  hintText: '例如 7890',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (!enable) return null;
                  final input = value?.trim() ?? '';
                  final number = int.tryParse(input);
                  if (input.isEmpty) return '请输入代理端口';
                  if (number == null || number < 1 || number > 65535)
                    return '端口范围为 1–65535';
                  return null;
                },
                onSaved: (value) => port = int.tryParse(value?.trim() ?? ''),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton.icon(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();
            bool isOK = await ref
                .read(userInfoStateProvider.notifier)
                .changeProxy(
              enable ? 1 : 2,
              enable ? host : '',
              enable ? port : null,
            );
            if (isOK) Navigator.pop(context);
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('保存设置'),
        ),
      ],
    );
  }
}
