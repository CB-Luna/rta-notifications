import 'package:supabase/supabase.dart';
//import 'dart:convert' as convert;
import '../constants.dart' as constants;

void main(List<String> args) async {
  await getConfig('credencialesOAuthMail');
}

String supabaseUrl = constants.supabaseUrl;
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UiLAogICAgImlhdCI6IDE2NTc2OTU2MDAsCiAgICAiZXhwIjogMTgxNTQ2MjAwMAp9.8h6s6K2rRn20SOc7robvygAWNhZsSWD4xFRdIZMyYVI';
final client = SupabaseClient(supabaseUrl, supabaseKey);

getConfig(String config) async {
  String resp = '';

  try {
    final selectResponse = await client
        .from('configs')
        .select('value')
        .eq('label', config)
        .execute(count: CountOption.exact);
    if (selectResponse.error == null) {
      //print('response.data: ${selectResponse.data}');
      resp = selectResponse.data[0]['value'];
    }
  } catch (e) {
    print('getConfig()_Exception: $e');
  }

  return resp;
}
