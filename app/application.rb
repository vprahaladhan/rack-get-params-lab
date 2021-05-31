class Application

  @@cart = []
  @@items = ["Apples","Carrots","Pears"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      puts ("Path matches /cart/") 
      resp.write(@@cart.size == 0 ? "Your cart is empty!" : (@@cart.join("\n") + "\n"))
    elsif req.path.match(/add/)
      if @@items.include?(req.params["item"]) then
        @@cart << req.params["item"]
        resp.write("added #{req.params["item"]}")
      else 
        resp.write("We don't have that item")
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
