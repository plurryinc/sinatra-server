class Log < ActiveRecord::Base
  belongs_to :product

  serialize :message, Hash

  validates :created_at, uniqueness: true

  def self.create_log(product_id, msg)
    msg_hash = JSON.parse msg
    begin
      #it's real server
      if !msg_hash["rs"].nil?
        if [104, 106, 107, 110].include? msg_hash["rs"]
          Log.create({
            product_id: product_id,
            message: msg_hash,
            message_type: "rs",
            message_code: msg_hash["rs"]
          })
        end
=begin
      #it's test
      if !msg_hash["cmd"].nil?
        unless [8, 9].include? msg_hash["cmd"]
          Log.create({
            product_id: product_id,
            message: msg_hash,
            message_type: "cmd",
            message_code: msg_hash["cmd"]
          })
        end
=end
      elsif !msg_hash["report"].nil?
        Log.create({
          product_id: product_id,
          message: msg_hash,
          message_type: "report",
          message_code: msg_hash["report"]
        })
      else
        puts "not save Log...because it's not Hash and...is_valid_json? method not running"
      end
    rescue Exception => e
      puts "save Log fail because... => #{e.message}"
    end
  end

  def dashboard
    if message_type == "rs"
      case message_code
      when 104
        unless message["timestamp"].nil?
          time = secondToStringTime message["timestamp"]
          "#{time} 으로 스케쥴이 추가 되었습니다."
        end
      when 106
        "#{message["amount"]} 만큼(최소 1 ~ 최대 9) 밥을 수동으로 주었습니다."
      when 107
        if message["amount"] == 0
          "사료통이 비었습니다. 사료를 채워 넣어주세요."
        else
          "#{message["amount"]} / 3 만큼 남아있습니다."
        end
      when 110
        if message["amount"] == 0
          "배터리가 거의 없습니다."
        else
          "배터리가 #{message["amount"] + 1} / 3 만큼 남았습니다."
        end
      else
      end
    elsif message_type == "report"
      case message_code
      when 201
        "스케쥴에 따라서 밥을 주었습니다."
      when 202
        if message["amount"] == 0
          "배터리가 거의 없습니다."
        else
          "배터리가 #{message["amount"] + 1} / 3 만큼 남았습니다."
        end
      else
      end
    end
  end

  def secondToStringTime sec
    Time.at(sec).utc.strftime("%I:%M %P")
  end

  def created_time
    elapsed_time = (Time.now - created_at).to_i

    minute, second = elapsed_time.divmod 60
    hour, minute = minute.divmod 60
    day, hour = hour.divmod 24

    if day > 0
      created_time = "#{day}일 #{hour}시간 전"
    elsif hour > 0
      created_time = "#{hour}시간 #{minute}분 전"
    elsif minute > 0
      created_time = "#{minute}분 #{second}초 전"
    elsif second > 0
      created_time = "1 분 전"
    elsif second == 0
      created_time = '방금'
    end

    created_time
  end
end
