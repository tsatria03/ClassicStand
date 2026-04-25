Welcome to ClassicStand!
In this game, you run your own lemonade business in a fully navigable neighborhood map. Walk around, buy ingredients at the market, make and pour lemonade at your stand, and serve customers. The goal is to keep your reputation high, earn as much money as possible, and survive the daily grind of running a real business.

Getting started:
From the main menu, choose game menu, then new game, and select a save slot. You will be asked to set a business title before starting.

Moving around:
Use the arrow keys to walk around the neighborhood map. Hold control or alt while walking to run. Hold shift and press an arrow key to turn without moving. Your current zone is announced as you walk, and you can press Q at any time to hear your current location.

Interacting with stations:
There are 3 stations on the map, each activated by pressing enter when you are standing in the right area.
The actions station is located at your lemonade stand. Make and pour lemonade here.
The customer service counter is also located at your lemonade stand. Serve waiting customers here.
The buying station is located inside the market to the east. Buy ingredients and posters here.

Making lemonade:
When you make lemonade at the actions station, you will be asked how many cups to make, followed by how much of each ingredient to add. Each prompt prefills a suggested balanced amount based on how many cups you are making, targeting one of each main ingredient per cup and a small amount of ice and salt. If you enter an amount that differs from the suggestion, a confirmation menu will warn you of the likely result and let you revert or proceed. Getting the balance right matters because customers will react based on how the drink tastes.

Pricing:
At the start of each day you are asked to set your price per cup. A suggested price is shown based on your current day and level. The minimum is the suggested price and the maximum is four times the suggested price. Prices between one and two times the suggested price cause customers to hesitate. Prices above two times the suggested price give customers a chance to refuse outright, with the chance increasing the higher you go. Desperate customers never refuse no matter the price.

Serving customers:
When customers arrive at the counter, press enter to open the serve menu. This lists all waiting customers along with their direction and type. Patience timers are frozen while the menu is open. From here you can select an individual customer to talk or serve them, or choose serve all to handle everyone at once with a single drink sequence followed by a full summary. If you leave customers waiting too long without opening the menu, their patience will run out and they will leave on their own with a reputation penalty. Different customer types have different patience levels, so some will wait longer than others.

Customer types:
There are 11 customer types, each with unique behavior, patience, and reactions.

Normal: A standard customer with no special traits.
Nice: Friendly, forgiving of high prices, and more likely to tip.
Mean: Always complains regardless of recipe quality. Never tips.
Desperate: Sprints to your stand and pays 50 percent more. Never refuses on price.
Charitable: Buys a cup to deliver to someone else. Takes the cup away without drinking at the stand. Always tips generously.
Group: Orders multiple cups for their whole group. You need enough filled cups for everyone.
Returning: A happy customer from before. Always enjoys their drink and is more likely to tip.
Critic: A reviewer taking notes. Reacts much more harshly to bad lemonade but gives a large reputation boost for a good one.
Elderly: Moves slowly, very patient, and enjoys conversation the most.
Child: Runs to your stand but pays less. Most sensitive to high prices.
Thief: Attempts to steal ingredients when they reach your stand. Chase them by stepping on their tile to recover your goods and earn a small reputation boost.

Talking to customers:
Select a customer from the serve menu and choose talk to chat with them. Each type has unique things to say. Talking too many times will exhaust their patience and they will leave with a small reputation penalty.

Customer reactions:
Perfectly balanced lemonade earns a happy reaction. The customer drinks, hands back the cup, and may leave a tip.
Mildly unbalanced lemonade causes a verbal complaint. The customer still drinks and pays but your reputation drops slightly.
Severely unbalanced lemonade causes a full tantrum. The customer spits it out, spills on the counter, refuses to pay, and storms off with a large reputation penalty.

Spills and napkins:
When a customer spills their drink, the counter becomes wet. The greeter will offer you a napkin. Use the napkin on the wet tile to clean it up, then recycle the used napkin from your inventory with shift enter.

Reputation:
Your reputation starts at 100 and ranges from 0 to 200. Serving customers well raises it. Letting customers leave unserved or giving them bad lemonade lowers it. Tipping chance and amount scale with your reputation. If your reputation hits zero the game ends.

Random events:
At the end of each time period there is a chance of a random event. Hot days can trigger free water donations or heatstroke costs. Cold days can cause slow business or freeze your ingredients. Other events include a lucky viral bonus or a thief stealing from your cash box overnight.

Keyboard shortcuts:
A: Speak arriving customer count.
W: Speak waiting customer count.
L: Speak leaving customer count.
R: Speak your current reputation.
I: Open the business information screen.
B: Speak your business title.
D: Speak the current date.
T: Speak the current time and level.
M: Speak the current temperature.
C: Speak your current cash.
F: Speak your filled cup count.
S: Speak your sold cup count.
P: Speak your passerby count.
N: Skip to the next time period when the wave is over.
Q: Speak your current location.
Z: Toggle zone announcements on or off.
X: Speak your exact coordinates and surface.
Tab: Cycle forward through your inventory.
Shift+Tab: Cycle backward through your inventory.
Shift+Enter: Use or recycle the selected inventory item.
Control+S: Save your game.
Control+L: Reload your game.
Alt+F4: Exit to the main menu without saving.
Escape: Open the quit menu.

Configuration files

All configuration files are located in the data/config folder, split into three subfolders: events, stores, and tables.
Lines starting with a semicolon, hash, or double slash are treated as comments and ignored by the parser.

Four files, main.table and customers.table, use section headers in square brackets such as [newgame], [thresholds], [items], [types], [waves], [movements], and [speeches]. These are not cosmetic. The parser uses them to know which format to expect. Do not remove or rename these headers or the parser will not read the file correctly.

The remaining files, main.event, single_ingredients.store, bundle_ingredients.store, single_posters.store, and bundle_posters.store, do not use functional section headers. Every line in those files follows the same format throughout.

Sections that use key=value pairs are for flat settings with a single value per entry. Sections that use colon-delimited rows are for data entries with multiple fields per line.

main.event

Location: data/config/events/main.event

Defines all random events that can fire at the end of a time period.

Format: event_name:sound:polarity:target:min_amount:max_amount:use_percent:condition:chance:description

event_name
The internal name of this event. Used for identification only.

sound
The sound file to play when this event fires, relative to sounds/misc/. Use a random range by writing the number part as (min,max). Example: buy(1,4).ogg picks randomly from buy1, buy2, buy3, or buy4. Set to none to play no sound.

polarity
Whether this event helps or hurts the player.

1 = positive. The event gives the player something.
2 = negative. The event takes something away.
0 = neutral. No effect on any stat.

target
The stat this event affects.

cash = the player's current cash.
water = the player's water supply.
sugar = the player's sugar supply.
salt = the player's salt supply.
posters = the player's placed posters.
none = no stat is affected.

min_amount and max_amount
The range of values the effect rolls between. Supports expressions using level, day, and placed as variables with the operators *, /, +, and -. Examples: 5*level*day, placed/2, 100.

use_percent

false = the rolled amount is applied directly.
true = the rolled amount is treated as a percentage of the player's current stat.

condition
Controls which weather condition can trigger this event.

hot = only fires when temperature is above the hot threshold.
cold = only fires when temperature is below the cold threshold.
posters = only fires when at least one poster is placed.
any = fires regardless of weather.

chance
The probability of this event firing when selected, from 1 to 100. Set to 0 to disable without removing the line.

description
The message spoken to the player when this event fires. Use %amount% as a placeholder for the rolled value.

single_ingredients.store

Location: data/config/stores/single_ingredients.store

Defines all single ingredients available for purchase in the market.

Format: item_id:display_name:target:base_cost:cost_expr:description

item_id
The internal identifier for this ingredient. Must match the variable name used in the game code.

display_name
The name shown in the store menu.

target
The inventory variable this ingredient adds to when purchased.

base_cost
The starting price before any scaling.

cost_expr
An expression that controls how the cost scales. Supports level and day as variables. Example: level*day multiplies the base cost by the current level and day number.

description
Shown in the store menu. Use %stock% as a placeholder for the player's current quantity of this item.

bundle_ingredients.store

Location: data/config/stores/bundle_ingredients.store

Defines all ingredient bundle tiers available in the market.

Format: bundle_id:display_name:quantity:description

bundle_id
The internal identifier for this bundle.

display_name
The name shown in the bundle menu.

quantity
How many of each core ingredient (cups, lemons, sugar, water) the bundle contains. Ice and salt are optional add-ons the player is asked about at purchase time.

description
Shown in the bundle menu. Use %quantity% as a placeholder for the bundle quantity.

single_posters.store

Location: data/config/stores/single_posters.store

Defines all poster types available in the poster shop.

Format: item_id:display_name:base_cost:cost_expr:description

item_id
The internal identifier for this poster type.

display_name
The name shown in the store menu.

base_cost
The starting price before any scaling.

cost_expr
An expression controlling how the cost scales. Supports level and day. Example: level*day.

description
Shown in the store menu. Use %stock% as a placeholder for the player's current quantity of this poster type.

bundle_posters.store

Location: data/config/stores/bundle_posters.store

Defines all poster bundle packs available in the poster shop.

Format: bundle_id:display_name:basic_qty:colorful_qty:premium_qty:discount:description

bundle_id
The internal identifier for this bundle.

display_name
The name shown in the bundle menu.

basic_qty, colorful_qty, premium_qty
How many of each poster type the bundle contains.

discount
The price discount applied to this bundle as a multiplier. Example: 0.9 means the bundle costs 10 percent less than buying the posters individually.

description
Shown in the bundle menu. Use %basic%, %colorful%, and %premium% as placeholders for the respective quantities.

main.table

Location: data/config/tables/main.table

Defines starting inventory values, lemonade quality thresholds, and item properties.

[newgame]
Flat key=value settings for starting a new game.

cash = starting cash in cents.
reputation = starting reputation out of 200.
cups_min and cups_max = random range for starting empty cups.
lemons_min and lemons_max = random range for starting lemons.
sugars_min and sugars_max = random range for starting sugar packets.
waters_min and waters_max = random range for starting liters of water.
ices_min and ices_max = random range for starting bags of ice.
salts_min and salts_max = random range for starting salt packets.

[thresholds]
Flat key=value ratios controlling lemonade quality feedback.

sour and extreme_sour = lemon ratio thresholds for mild and extreme sourness complaints.
sweet and extreme_sweet = sugar ratio thresholds for mild and extreme sweetness complaints.
watery and extreme_watery = water ratio thresholds for mild and extreme watery complaints.
salty and extreme_salty = salt amount thresholds for mild and extreme saltiness complaints.
icy and extreme_icy = ice amount thresholds for mild and extreme iciness complaints.

[items]
Defines every item in the game.

Format: item_id:display_name:useable:recycleable:use_action

item_id
The internal identifier for this item. Must match the key used in the inventory system.

display_name
The name shown to the player in inventory and menus.

useable
true if pressing shift+enter on this item triggers a use action. false otherwise.

recycleable
true if pressing shift+enter on this item discards it from inventory. false otherwise.

use_action
The action performed when the item is used. Set to none if the item is not useable.

clean_spill = cleans a wet tile at the customer counter.
toss = discards the item silently.
place_poster = places the poster on the neighborhood street.
inspect_cup = opens the filled cup inspection menu.

customers.table

Location: data/config/tables/customers.table

Defines all customer behavior including spawn weights, wave rules, movement, and dialogue.

[types]
Flat key=value spawn weights for each customer type. Higher values make that type more likely to appear.

[waves]
Flat key=value settings controlling wave size.

base_min and base_max = random base customer count per wave.
extra_max = maximum bonus customers added from level scaling.
poster_wave_bonus = additional customers added per placed poster.
max_customers = hard cap on total customers per wave.
cold_guaranteed_min and cold_guaranteed_max = guaranteed customer count on cold days.
cold_temp = temperature below which cold rules apply.
hot_temp = temperature above which hot rules apply.

[movements]
Per-type movement and patience multipliers.

Format: type:speed_multiplier:patience_multiplier:use_patience

speed_multiplier scales how fast this customer type walks. Values above 1.0 are slower, below 1.0 are faster.
patience_multiplier scales how long this type waits before leaving. Values above 1.0 are more patient, below 1.0 are less patient.
use_patience controls whether the patience timer is active for this type. Set to false for types that manage their own leaving logic.

[speeches]
Dialogue lines for each customer type.

Each type block starts with type=count, where count is the number of regular talk lines.

Each line follows the format: line_number:mood:text

The line numbered one above the count is the walkoff line, spoken when the player has talked to the customer too many times.
Mood tags are internal labels describing the customer's emotional state on that line. They are cosmetic for now and do not affect gameplay.

Use %group_size% in group customer lines as a placeholder for the number of people in the group.

Game conclusion

Classic Stand started as a simple lemonade selling game and has grown into a full-featured business simulation with a live customer system, a dynamic neighborhood map, random events, a poster marketing system, multiple save slots, and deep modding support.
Every system in the game, from customer behavior to event effects to store prices, can be tuned or extended through the provided configuration files.

Whether you are a player looking to understand the game better, or a modder building your own experience on top of it, we hope this document gives you everything you need to succeed in the lemonade making business.
Thanks for playing, and happy selling!
