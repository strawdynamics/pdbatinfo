return [[*pdbatinfo*

This simple app displays the current battery charging state, voltage, and estimated % remaining (state of charge) using Panic-provided APIs. It also includes some general information about the Playdate battery, and why the Playdate's battery indicator isn't as accurate as, say, a smartphone's.

pdbatinfo is not affiliated with or endorsed by Panic. I'm just a Playdate fan, not an electrical engineer. Be smart, do your own research, and make sure you understand what you read. Conversely, if you see something incorrect or missing below and have better info, let me know! This text and code are public domain, I claim no copyright or other rights.

-paul


*Playdate's battery*

There are many types of battery chemistry, and all of them have unique properties. Even just within lithium-ion batteries, there's different performance between factories, chemistry changes over time, etc. The Wikipedia article on lithium-ion batteries[^1] lists their specific energy as anywhere from 100-265 Wh/kg, quite a range! This is focused only on what's inside Playdate and why it works the way it does. It's not intended to be a general primer on batteries.

Playdate contains a rechargeable lithium-ion battery with a rated 740 mAh capacity (2.74 Wh at 3.7 V)[^2]. This type of battery is very similar to what's used in smartphones. To put the capacity in context, most smartphones have batteries that hold 3-5000 mAh (~11-19 Wh). Panic lists the Playdate battery as "14 days standby clock", and "8 hours active".

Just like any other piece of electronics, performing different tasks places different demands on Playdate's battery. Purchasing and downloading games is one example of an energy-intensive task that surprises many people. Using the Wi-Fi radio and doing lots of disk writes are both expensive, though! Apps and games all have unique energy needs depending on what they do and how heavily they've been optimized.


*State of charge*

State of charge (SoC) is a fancy term for the answer to to the age-old question "How much longer is this thing gonna last?" Unlike a tank of water, you can't simply look at or weigh a battery to determine its capacity. One way of estimating SoC is to check the battery voltage.

Batteries are commonly said to be "fully" charged or discharged when their resting voltage is some number depending on their chemistry. For 3.7 V nominal lithium-ion batteries, 4.2 V is usually fully charged, while fully discharged is around 3.2 V. However, using voltage alone to determine state of charge is limited for several reasons.

First, batteries are designed to provide as close to a constant voltage as possible throughout their discharge cycle. This design goal is directly counter to the goal of getting a precise SoC measurement from voltage alone. Lithium-ion batteries also happen to have a particuarly flat "discharge curve", making this approach even less accurate than usual.

Note that I said "resting" voltage above when talking about batteries being fully charged or discharged. As the load on a battery changes, its voltage also changes. A large load causes the battery voltage to drop more than a small one. However, when the load is removed, the voltage will creep back up to a point. Therefore, reading instantaneous voltage also doesn't tell you much unless you also know the load (discharge current) at that time.

The varying load on the battery also plays a role in the battery's effective capacity! In an "ideal battery", it wouldn't matter how quickly you drained it. If you could pull 10 Wh from a battery, it wouldn't matter if you did it in 5 hours or 5 minutes. However, in the real world, draining a battery more quickly does reduce its effective capacity. This effect can be approximated using a formula called Peukert's law, but again, the discharge current must be known to apply it.


*Beyond voltage*

If you noticed that most of the issues above could be solved by measuring current in addition to voltage, congratulations! You're right on, they could be! However, measuring current requires additional circuitry not present in Playdate hardware[^3].

Instead, Playdate uses a map of voltages to percentages (likely some sort of lookup table or function) while charging or discharging. It also applies some logic when switching between charging states (and may take other things into account that haven't been made public). However, this approach will always be limited due to the issues mentioned above (and others not mentioned).

Personally, my recommendation is to regularly charge and use your Playdate, and try not to worry too much about what the SoC estimate says. Just one more reason to get into Playdate dev: you'll probably never have to think about charging again!

[^1]: https://en.wikipedia.org/wiki/Lithium-ion_battery
[^2]: https://www.ifixit.com/Teardown/Playdate+Teardown/143811#s291107
[^3]: https://devforum.play.date/t/battery-charges-slowly/11843/17
]]
