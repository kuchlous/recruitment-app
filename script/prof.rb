#require 'profiler'
require 'ruby-prof'
profout = File.new('script/joined.prof', 'w')
c = ResumesController.new
#Profiler__::start_profile
RubyProf.start
c.joined
#matches = c.get_all_req_matches_of_status("JOINING")
result = RubyProf.stop
#Profiler__::stop_profile
#Profiler__::print_profile(profout)
printer = RubyProf::GraphPrinter.new(result)
printer.print(profout, 0)
profout.close
