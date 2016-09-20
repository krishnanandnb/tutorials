require "time"
class BusinessHours 
	DAYS = [:Mon,:Tue,:Wed,:Thu,:Fri,:Sat,:Sun]
	DATE_FORMAT = "%d-%m-%Y"
	OUTPUT_DATE_FORMAT = "%a %b %d %H:%M:%S %Y"
	def initialize(begin_time,end_time)
		@week = Hash.new
		working_hours = [begin_time,end_time]
		DAYS.each{ |day | @week[day] = working_hours }
		@hash_days=Hash[DAYS.map.with_index.to_a] 
	end

	def update(day,begin_time,end_time)
		assign_timings(day,[begin_time,end_time])
	end

	def closed(day1,*days)
		@week[day1] = [0,0]
		days.each { |day| assign_timings(day,[0,0]) }
	end

	private

	def assign_timings(day,begin_end)
		if day.instance_of? Symbol
			@week[day] = begin_end
		else
			day=Time.parse(day).strftime(DATE_FORMAT)
			@week[day]=begin_end

		end
	end

	def getClosingTime(estimated_time)
		getStartandEndTime(estimated_time,1)
	end

	def getStartTime(start_time)
		getStartandEndTime(start_time,0)
	end

	def getStartandEndTime(start_time,index)
		date=start_time.strftime(DATE_FORMAT)
		return "#{date}+" "+#{@week[date][index]}" if @week[date]
		day_of_theweek=start_time.strftime("%a").to_sym
		"#{date}+" "+#{@week[day_of_theweek.to_sym][index]}"
	end

	def checkforHoliday?(date)
		 @week[date] ? @week[date][0]==0 : false
	end
		 
			
	def getNextDay(start_time)
		day=start_time.strftime("%a")
		day_index=getDayIndex(day.to_sym)
		new_date=start_time
		begin
		day_index=(day_index+1)%7	
		new_date=(new_date+24*60*60)
		end while @week[DAYS[day_index]][0]==0 || (checkforHoliday? new_date.strftime(DATE_FORMAT))
		return @week[new_date][0] if @week[new_date]
		return "#{new_date.strftime(DATE_FORMAT)} #{@week[DAYS[day_index]][0]}"
	end

	def getDayIndex(day)
		@hash_days[day]
	end

	public

	def calculate_deadline(interval,start_time)
		start_time_parsed=Time.parse start_time
		start_time_of_day=Time.parse(getStartTime(Time.parse(start_time)))
		estimated_time=start_time_of_day < start_time_parsed ? start_time_parsed+interval : start_time_of_day+interval
		closing_time =Time.parse(getClosingTime(estimated_time))
			if closing_time > estimated_time
				return estimated_time.strftime(OUTPUT_DATE_FORMAT)
			else
				remaining_time=estimated_time - closing_time
				next_start_time=getNextDay(start_time_parsed)
				calculate_deadline(remaining_time,next_start_time)
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