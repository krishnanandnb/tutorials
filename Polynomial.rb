class Polynomial
  def initialize(coefs)
  	raise ArgumentError, 'Need at least 2 coefficients' if coefs.length < 2
  	@coefs =coefs
  	build()
  end
  def build()
    digree = @coefs.length-1
    polynomial = ""
    polynomial +="#{@coefs[0]}x^#{digree}" if @coefs[0] != 0 
    new_coefs= @coefs.slice(1, digree-1)
    counter = new_coefs.length
    new_coefs.each do |x|
		if x == 1
		  polynomial += "+x^#{counter}"
		elsif x < 0
		  polynomial += "#{x}x^#{counter}"
		elsif x == 0
		  counter-=1
		  next
		else
			polynomial += "+#{x}x^#{counter}"
		end
		counter-=1	
	end
    puts @coefs[digree]<0 ? "#{polynomial}#{@coefs[digree]}" : "#{polynomial}+#{@coefs[digree]}"
  end
end
puts Polynomial.new([-3,-4,1,0,6])