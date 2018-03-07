

def harry_potter()
  tune = [[60,0.5], [65, 0.75], [68,0.25], [67, 0.5], [65,1], [72,0.5],[70,1.25],[67, 1.5],
          [65, 0.75], [68,0.25], [67, 0.5], [64,1],[68, 0.5], [60,1],
          [60,0.5], [65, 0.75], [68,0.25], [67, 0.5], [65,1], [72, 0.5], [75, 1], [74, 0.5], [73, 1],
          [68, 0.5], [72, 1], [70, 0.5], [65, 1], [68,0.5], [65,1]]
  
  volume = 1
  speed = 0.95
  
  tune.length.times do |x|
    knob, amount = get "/midi/nanokontrol_slider_knob/0/1/control_change"
    if knob == 14 || knob ==15
      volume = volume_control()
    elsif knob == 2 || knob == 3
      speed = (speed_control()) * 0.7
    else
    end
    
    pitch = tune[x][0]
    time = (tune[x][1]) / speed
    synth :pretty_bell, note: pitch, release: time + 0.75, attack: 0.25, amp: volume
    sleep time
  end
end


def jeopardy()
  tune = [[65, 1], [70, 1], [65,1], [58, 1], [65,1], [70,1],[65,2],
          [65, 1], [70, 1], [65,1], [70, 1], [74,1.5], [72, 0.5], [70, 0.5], [69, 0.5], [67, 0.5], [66, 0.5],
          [65, 1], [70, 1], [65,1], [58, 1], [65,1], [70,1],[65,2],
          [70, 1.5], [67,0.5], [65, 1], [63, 1], [62, 1], [60, 1], [58,1]]
  x = 0
  volume = 1
  speed = 1
  
  while x < tune.length
    knob, amount = get "/midi/nanokontrol_slider_knob/0/1/control_change"
    
    if knob == 14 || knob == 15
      volume = volume_control()
    elsif knob == 2 || knob == 3
      speed = speed_control()
    else
    end
    
    pitch = tune[x][0]
    time = tune[x][1] / speed
    synth :piano, note: pitch, amp: volume, release: time + 1
    synth :hollow, note: pitch, amp: volume, release: time + 0.5
    sleep time
    x = x + 1
  end
end


def volume_control()
  knob, amount = get "/midi/nanokontrol_slider_knob/0/1/control_change"
  volume = (amount + 5) / 5
end


def speed_control()
  knob, amount = get "/midi/nanokontrol_slider_knob/0/1/control_change"
  speed = (amount * 0.055) + 1.5
end


loop do
  button = 0
  live_loop :midi do
    button, active = sync "/midi/nanokontrol_slider_knob/0/1/control_change"
    if button == 23
      harry_potter()
    elsif button == 24
      jeopardy()
    end
  end
  sleep 0.25
end
