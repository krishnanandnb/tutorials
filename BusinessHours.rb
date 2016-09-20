require "time"
class BusinessHours 
	DAYS =[:Mon,:Tue,:Wed,:Thu,:Fri,:Sat,:Sun]
	def initialize(begin_time,end_time)
		@week = Hash.new
		working_hours = [begin_time,end_time]
		DAYS.each{ |day | @week[day] = working_hours }
		@hash_days=Hash[DAYS.map.with_index.to_a] 
	end
	def update(day,begin_time,end_time)
		if day.instance_of? Symbol
			@week[day] = [begin_time,end_time]
		else
			day=Time.parse(day).strftime("%d-%m-%Y")
			@week[day]=[begin_time,end_time]

		end
	end
	def closed(day1,*days)
		@week[day1] = [0,0]
		days.each do |day| 
			if day.instance_of? Symbol
				@week[day]=[0,0] 
			else
				day=Time.parse(day).strftime("%d-%m-%Y")
				@week[day]=[0,0]
			end
		end
	end
	def checkForSameDay? (start_time_parsed,estimated_time)
		start_time_parsed.strftime("%d-%m-%Y")==estimated_time.strftime("%d-%m-%Y")
	end
	def getClosingTime(estimated_time)
		date=estimated_time.strftime("%d-%m-%Y")
		return "#{date}+" "+#{@week[date][1]}" if @week[date]
		day_of_theweek=estimated_time.strftime("%a").to_sym
		"#{date}+" "+#{@week[day_of_theweek.to_sym][1]}"
	end
	def getStartTime(start_time)
		date=start_time.strftime("%d-%m-%Y")
		return "#{date}+" "+#{@week[date][0]}" if @week[date]
		day_of_theweek=start_time.strftime("%a").to_sym
		"#{date}+" "+#{@week[day_of_theweek.to_sym][0]}"
	end
	def checkforHoliday?(date)
		if @week[date].nil? 
			false 
		 else
		    @week[date][0]==0
		end
	end
		 
			
	def getNextDay(start_time)
		day=start_time.strftime("%a")
		day_index=getDayIndex(day.to_sym)
		new_date=start_time
		begin
		day_index=(day_index+1)%7	
		new_date=(new_date+24*60*60)
		end while @week[DAYS[day_index]][0]==0 || (checkforHoliday? new_date.strftime("%d-%m-%Y"))
		return @week[new_date][0] if @week[new_date]
		return "#{new_date.strftime("%d-%m-%Y")} #{@week[DAYS[day_index]][0]}"
	end
	def getDayIndex(day)
		@hash_days[day]
	end
	def calculate_deadline(interval,start_time)
		start_time_parsed=Time.parse start_time
		start_time_of_day=Time.parse(getStartTime(Time.parse(start_time)))
		estimated_time=start_time_of_day < start_time_parsed ? start_time_parsed+interval : start_time_of_day+interval
		if checkForSameDay? start_time_parsed,estimated_time
			closing_time =Time.parse(getClosingTime(estimated_time))
			if closing_time > estimated_time
				#puts closing_time
				#puts estimated_time
				return estimated_time.strftime("%a %b %d %H:%M:%S %Y")
			else
				remaining_time=estimated_time - closing_time
				next_start_time=getNextDay(start_time_parsed)
				#puts "next day start"+next_start_time
				calculate_deadline(remaining_time,next_start_time)
			end
		else

		end
	end
	
end
hours = BusinessHours.new("9:00 AM", "3:00 PM")
hours.update :Fri, "10:00 AM", "5:00 PM"
hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"	
hours.closed :Sun, :Wed, "Dec 25, 2010"
puts hours.calculate_deadline(2*60*60, "Jun 7, 2010 9:10 AM")
puts hours.calculate_deadline(15*60, "Jun 8, 2010 2:48 PM")
puts hours.calculate_deadline(7*60*60, "Dec 24, 2010 6:45 AM") 