abstract final class AppsFlyerConfig {
  static const String devKey = String.fromEnvironment(
    'AF_DEV_KEY',
    defaultValue: 'FPEgKiz7rGw6g25ip54pKi',
  );

  static const String iosAppId = String.fromEnvironment(
    'AF_IOS_APP_ID',
    defaultValue: '',
  );

  static const String trackerUrl =
      'https://chokido.store/Sm5b3HhM'
      '?sub_id_1={appsflyer_id}'
      '&sub_id_2={install_source}'
      '&sub_id_3={media_source}'
      '&sub_id_4={af_status}'
      '&sub_id_5={campaign_id}'
      '&sub_id_6={campaign_name}'
      '&sub_id_7={adset_id}'
      '&sub_id_8={adset_name}'
      '&sub_id_9={channel}'
      '&sub_id_10={customer_user_id}';
}
