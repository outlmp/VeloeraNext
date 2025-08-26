-- 初始化数据脚本
-- 创建默认管理员用户和基础配置

-- 插入默认管理员用户 (用户名: admin, 密码: admin123)
-- 密码使用 bcrypt 加密，$2a$10$... 对应 "admin123"
INSERT OR IGNORE INTO users (
    id, username, password, display_name, role, status, email, github_id, 
    wechat_id, lark_id, access_token, quota, used_quota, request_count, group_name,
    affiliation, inviter_id, created_time, updated_time
) VALUES (
    1, 'admin', '$2a$10$Ow9ZHdLpyTT0h7SR38.syeqFV.ZQiF/9.4/fkj8U8XQ.7nV9KZy5W', 
    '系统管理员', 100, 1, 'admin@veloera.local', '', 
    '', '', 'sk-admin-' || hex(randomblob(20)), 10000000, 0, 0, 'default',
    'Veloera', 0, datetime('now'), datetime('now')
);

-- 插入系统基础配置选项
INSERT OR IGNORE INTO options (key, value) VALUES 
('TopUpLink', ''),
('ChatLink', ''),
('QuotaPerUnit', '500000'),
('RetryTimes', '3'),
('InitialQuota', '100000'),
('PreConsumedQuota', '500'),
('StreamCacheQueueLength', '10'),
('MaxRequestSizeKB', '2048'),
('RequestRateLimitKeyExpirationDuration', '600'),
('TurnstileSiteKey', ''),
('TurnstileSecretKey', ''),
('RegisterEnabled', '1'),
('EmailVerificationEnabled', '0'),
('GitHubOAuthEnabled', '0'),
('GitHubClientId', ''),
('GitHubClientSecret', ''),
('WeChatAuthEnabled', '0'),
('WeChatServerAddress', ''),
('WeChatServerToken', ''),
('WeChatAccountQRCodeImageURL', ''),
('MessagePusherAddress', ''),
('MessagePusherToken', ''),
('TelegramBotToken', ''),
('TelegramBotName', ''),
('LarkClientId', ''),
('LarkClientSecret', ''),
('DataExportInterval', '5'),
('DataExportEnabled', '0'),
('DefaultCollapseSidebar', '0'),
('Logo', ''),
('HomePageContent', '<h1>欢迎使用 Veloera</h1><p>这是一个功能强大的 AI API 网关服务。</p>'),
('About', ''),
('Notice', ''),
('SMTPServer', ''),
('SMTPPort', '587'),
('SMTPAccount', ''),
('SMTPToken', ''),
('SMTPFrom', ''),
('ServerAddress', 'http://localhost:3300'),
('WorkerUrl', ''),
('WorkerValidKey', ''),
('PaymentUSDRate', '7.3'),
('MinTopUp', '1'),
('TopupGroupRatio', '{}'),
('ChannelDisableThreshold', '100'),
('QuotaRemindThreshold', '1000'),
('PreConsumedQuota', '500'),
('ModelRatio', '{}'),
('ModelPrice', '{}'),
('GroupRatio', '{}'),
('UserUsableGroups', '["default"]'),
('ModelMapping', '{}'),
('CompletionRatio', '{}'),
('RedemptionEnabled', '1'),
('TaskEnabled', '1'),
('DrawingEnabled', '1'),
('MjNotifyEnabled', '0'),
('MjAccountFilterEnabled', '0'),
('MjModeClearEnabled', '1'),
('MjForwardUrlEnabled', '0'),
('SunoEnabled', '0');

-- 插入默认分组
INSERT OR IGNORE INTO groups (name, description) VALUES 
('default', '默认分组'),
('vip', 'VIP 用户分组'),
('enterprise', '企业用户分组');

-- 插入示例渠道 (OpenAI API)
INSERT OR IGNORE INTO channels (
    id, type, key_value, status, name, weight, created_time, test_time, response_time, 
    base_url, other, balance, balance_updated_time, used_quota, priority, auto_ban, 
    models, group_list, disabled_time, status_code_mapping, tag, config
) VALUES (
    1, 1, 'sk-example-key-replace-with-real-key', 1, 'OpenAI 示例渠道', 1, 
    datetime('now'), datetime('now'), 0, 'https://api.openai.com', '', 
    0, datetime('now'), 0, 0, 0, 
    '["gpt-3.5-turbo","gpt-4","gpt-4-turbo","text-davinci-003","text-embedding-ada-002"]', 
    '["default"]', 0, '{}', '', '{}'
);

-- 插入系统统计记录
INSERT OR IGNORE INTO logs (
    id, user_id, created_at, type, content, username, token_name, model_name, 
    quota, prompt_tokens, completion_tokens, channel, user_quota, request_id, 
    response_time, is_stream, multiplier, completion_ratio, channel_id, other
) VALUES (
    1, 1, datetime('now'), 1, '系统初始化', 'admin', 'system', 'system', 
    0, 0, 0, 1, 10000000, 'init-' || hex(randomblob(8)), 0, 0, 1.0, 1.0, 1, '{}'
);

-- 插入默认兑换码模板（如果启用兑换功能）
INSERT OR IGNORE INTO redemptions (
    id, user_id, key_value, status, name, quota, created_time, redeemed_time, 
    redeemed_by, is_gift, valid_from, valid_until, max_uses, used_count
) VALUES (
    1, 1, 'WELCOME-' || upper(hex(randomblob(4))), 0, '欢迎礼包', 50000, 
    datetime('now'), 0, 0, 1, datetime('now'), datetime('now', '+30 days'), 
    1, 0
);
