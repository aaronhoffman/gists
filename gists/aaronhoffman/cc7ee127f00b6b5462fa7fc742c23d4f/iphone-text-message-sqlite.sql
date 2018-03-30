-- more info http://aaron-hoffman.blogspot.com/2017/02/iphone-text-message-sqlite-sql-query.html
select
 m.rowid
,coalesce(m.cache_roomnames, h.id) ThreadId
,m.is_from_me IsFromMe
,case when m.is_from_me = 1 then m.account
 else h.id end as FromPhoneNumber
,case when m.is_from_me = 0 then m.account
 else coalesce(h2.id, h.id) end as ToPhoneNumber
,m.service Service

/*,datetime(m.date + 978307200, 'unixepoch', 'localtime') as TextDate -- date stored as ticks since 2001-01-01 */
,datetime((m.date / 1000000000) + 978307200, 'unixepoch', 'localtime') as TextDate /* after iOS11 date needs to be / 1000000000 */

,m.text MessageText

,c.display_name RoomName

from
message as m
left join handle as h on m.handle_id = h.rowid
left join chat as c on m.cache_roomnames = c.room_name /* note: chat.room_name is not unique, this may cause one-to-many join */
left join chat_handle_join as ch on c.rowid = ch.chat_id
left join handle as h2 on ch.handle_id = h2.rowid

where
-- try to eliminate duplicates due to non-unique message.cache_roomnames/chat.room_name
(h2.service is null or m.service = h2.service)

order by
 2 -- ThreadId
,m.date
