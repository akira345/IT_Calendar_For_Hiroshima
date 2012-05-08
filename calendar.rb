#!/usr/local/bin/ruby
#

#http://marnica.blog66.fc2.com/blog-entry-56.htmlより


require 'rubygems'
require 'icalendar'
require 'net/http'
require 'kconv'


#IT勉強会カレンダー
uri_str = 'http://www.google.com/calendar/ical/fvijvohm91uifvd9hratehf65k@group.calendar.google.com/public/basic.ics'

cals = nil
out_cal = Icalendar::Calendar.new

#新しいカレンダーを作成
out_cal.custom_property('X-WR-CALNAME', 'IT 勉強会カレンダー[広島]')
out_cal.custom_property('X-WR-CALDESC', '日本全国で開催される勉強会情報をまとめています。\n[開催地名] というように [　]で地名をタグ付していますので、開催地名
 での検索が可能です。\n同一日程に[☆]マークがあった場合は、同じ会場で開催されている勉強会が存在します。\n\n勉強会情報など、hanazukin+
 IT@gmail.com まで送信いただくと、追記させていただきます。\n※ 情報をいただく際に　http://d.hatena.ne.jp/hana
 zukin/20080603/1212461856　を一読お願いします。\n\n勉強会の元情報は↓をベースにしています。こちらのアンテナもぜひご使用く
 ださい。\nhttp://a.hatena.ne.jp/IT_Study_Seminar/\n\n※ 一か月表示のままでカレンダー内を検索される場合は
 、↓が便利です。\n　　http://utf-8.jp/tool/calsearch.html　（はせがわさん作）\n\n情報を利用される方へ\n1.
  こまめに日程や開催場所などを見ているつもりではありますが、入力後の変更などに対応しきれない場合や、\n　入力ミスがあるかもしれませんので、変更やミス
 を発見した場合は、ぜひ、お教えください。\n2. 情報をサイトなどへ取り込んで使用される際への利用に関しても、特に制限をしていませんのでご自由に活用し
 て下さい。\n　一報いただけると幸いです。\n　※ 最新の情報に更新されない場合や、更新が停止する場合もあります。
')
out_cal.custom_property('X-WR-TIMEZONE', 'Asia/Tokyo')


#データを取ってきてパース。
uri = URI.parse( uri_str )
req = Net::HTTP::Get.new uri.request_uri

Net::HTTP.start(uri.host, uri.port) do |http|
  cals = Icalendar::parse(http.request(req).body)
end

cal = cals.first

#イベント一覧
cal.events.each do |event|
  if ((/広島/ =~ event.summary.toutf8.to_s) || (/広島/ =~ event.location.toutf8.to_s)) then
 #p event
 #  puts "start:  " + event.dtstart.to_s
 #  puts "end:    " + event.dtend.to_s
 #  puts "uid:    " + event.uid.to_s
 #  puts "summary:" + event.summary.to_s
 #  puts "location:" + event.location.to_s
 #p  cal.find_event( event.uid.to_s)

	#新しいカレンダーを定義
	out_cal.event do
	    dtstart       event.dtstart
	    dtend         event.dtend
	    dtstamp       event.dtstamp
	    uid           event.uid.to_s
	    created       event.created
	    description   event.description.to_s
	    last_modified event.last_modified.to_s
	    location      event.location.toutf8.to_s
	    sequence      event.sequence.to_s
	    status        event.status.to_s
	    summary       event.summary.toutf8.to_s
	    transp        event.transp.to_s
	end

   end
end

#出力

File.open("./hiroshima.ics", "w+b") { |f|
    f.write(out_cal.to_ical.toutf8)
}
