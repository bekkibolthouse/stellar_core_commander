process :node1, [:node1, :node2, :node3], 2
process :node2, [:node1, :node2, :node3], 2
process :node3, [:node1, :node2, :node3], 2

on :node1 do
  start_load_generation 10000, 10000, 100
end

runs = 0
while runs == 0
  on :node2 do
    m = metrics
    puts "node2: transactions applied: #{m["ledger.transaction.apply"]["count"]}"
    puts "node2: transactions per sec: #{m["ledger.transaction.apply"]["mean_rate"]}"
    sleep 5
  end
  on :node1 do
    m = metrics
    runs = m["loadgen.run.complete"]["count"] rescue 0
  end
end
