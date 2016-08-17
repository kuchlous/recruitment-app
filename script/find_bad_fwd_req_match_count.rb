badrs = Resume.all.find_all { |r| 
          r.nreq_matches != r.req_matches.size ||
          r.nforwards != r.forwards.size}
