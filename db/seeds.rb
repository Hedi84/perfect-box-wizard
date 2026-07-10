puts "Clearing existing data..."

User.destroy_all
Onboarding.destroy_all
Recipe.destroy_all

DEFAULT_PASSWORD = "password123"

def create_user!(
  email:,
  first_name: nil,
  last_name: nil,
  address_line_1: nil,
  address_line_2: nil,
  city: nil,
  postcode: nil,
  dietary_preferences: [],
  current_step: "preferences",
  completed: true,
  role: nil
)
  user_attributes = {
    email:,
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD
  }

  user_attributes[:role] = role if role

  user = User.create!(user_attributes)

  user.create_onboarding!(
    first_name:,
    last_name:,
    address_line_1:,
    address_line_2:,
    city:,
    postcode:,
    dietary_preferences:,
    current_step:,
    completed_at: completed ? Time.current : nil
  )

  user
end

puts "Creating users and onboardings..."

create_user!(
  email: "alex@example.com",
  first_name: "Alex",
  last_name: "Morgan",
  address_line_1: "14 Willow Road",
  city: "Manchester",
  postcode: "M20 2AB",
  dietary_preferences: %w[vegetarian gluten_free]
)

create_user!(
  email: "jamie@example.com",
  first_name: "Jamie",
  last_name: "Taylor",
  address_line_1: "82 King Street",
  city: "Manchester",
  postcode: "M2 4WQ",
  dietary_preferences: %w[carnivore gluten_free]
)

create_user!(
  email: "sam@example.com",
  first_name: "Sam",
  last_name: "Patel",
  address_line_1: "7 Meadow Lane",
  city: "Salford",
  postcode: "M5 3AA",
  dietary_preferences: %w[vegan]
)

create_user!(
  email: "robin@example.com",
  first_name: "Robin",
  last_name: "Jones",
  address_line_1: "33 Park Avenue",
  city: "Manchester",
  postcode: "M14 6PL",
  dietary_preferences: %w[pescatarian]
)

create_user!(
  email: "casey@example.com",
  first_name: "Casey",
  last_name: "Williams",
  address_line_1: "5 Beech Close",
  city: "Stockport",
  postcode: "SK4 2LT",
  dietary_preferences: %w[vegetarian]
)

create_user!(
  email: "charlie@example.com",
  first_name: "Charlie",
  last_name: "Evans",
  address_line_1: "19 Chapel Street",
  city: "Manchester",
  postcode: "M3 5BZ",
  dietary_preferences: %w[flexitarian]
)

create_user!(
  email: "drew@example.com",
  first_name: "Drew",
  last_name: "Walker",
  address_line_1: "41 Oakfield Road",
  city: "Altrincham",
  postcode: "WA14 1RF",
  dietary_preferences: %w[carnivore]
)

create_user!(
  email: "admin@example.com",
  first_name: "Morgan",
  last_name: "Admin",
  address_line_1: "1 Kitchen Square",
  city: "Manchester",
  postcode: "M1 1AA",
  dietary_preferences: %w[vegan gluten_free],
  role: :admin
)

# Incomplete onboarding: the user has only just started.
create_user!(
  email: "personal.step@example.com",
  dietary_preferences: [],
  current_step: "personal",
  completed: false
)

# Incomplete onboarding: personal details are complete,
# but the user has not yet submitted their address.
create_user!(
  email: "address.step@example.com",
  first_name: "Jordan",
  last_name: "Brown",
  dietary_preferences: [],
  current_step: "address",
  completed: false
)

puts "Creating recipes..."

recipes = [
  {
    title: "Creamy Sweet Potato and Lentil Soup",
    body: "This sweet potato, carrot and red lentil soup has a creamy texture from coconut milk, with a fresh bite from lemon and chilli flakes. It is completely gluten free.",
    tags: %w[vegan gluten_free]
  },
  {
    title: "Roasted Cauliflower Chickpea Curry",
    body: "Roasted cauliflower and chickpeas are simmered in a warmly spiced tomato and coconut sauce, then served with fragrant rice.",
    tags: %w[vegan gluten_free]
  },
  {
    title: "Smoky Black Bean Tacos",
    body: "Soft tortillas are filled with smoky black beans, avocado, tomato salsa and crisp shredded lettuce.",
    tags: %w[vegan]
  },
  {
    title: "Mushroom and Spinach Risotto",
    body: "Creamy arborio rice is cooked slowly with mushrooms, spinach, garlic and vegetable stock.",
    tags: %w[vegan gluten_free]
  },
  {
    title: "Peanut Tofu Noodle Bowl",
    body: "Crispy tofu, crunchy vegetables and noodles are tossed in a rich peanut, lime and chilli dressing.",
    tags: %w[vegan]
  },
  {
    title: "Harissa Aubergine Couscous",
    body: "Roasted aubergine and chickpeas are paired with fluffy couscous, fresh herbs and a bright lemon dressing.",
    tags: %w[vegan]
  },
  {
    title: "Green Lentil Shepherd's Pie",
    body: "A savoury green lentil and vegetable filling is topped with fluffy mashed potato and baked until golden.",
    tags: %w[vegan gluten_free]
  },
  {
    title: "Coconut Lime Vegetable Stir Fry",
    body: "Seasonal vegetables are stir-fried in a fragrant coconut, lime and ginger sauce and served with rice.",
    tags: %w[vegan gluten_free]
  },

  {
    title: "Halloumi and Roasted Vegetable Traybake",
    body: "Salty halloumi is roasted with peppers, courgettes, tomatoes and red onion, then finished with fresh herbs.",
    tags: %w[vegetarian gluten_free]
  },
  {
    title: "Spinach and Ricotta Pasta Bake",
    body: "Pasta is baked with creamy ricotta, wilted spinach, tomato sauce and a bubbling golden cheese topping.",
    tags: %w[vegetarian]
  },
  {
    title: "Butternut Squash and Sage Gnocchi",
    body: "Soft gnocchi is tossed with roasted butternut squash, sage, brown butter and parmesan.",
    tags: %w[vegetarian]
  },
  {
    title: "Three Cheese Mushroom Pizza",
    body: "A homemade pizza base is topped with mushrooms, mozzarella, cheddar, parmesan and fresh thyme.",
    tags: %w[vegetarian]
  },
  {
    title: "Broccoli and Cheddar Frittata",
    body: "Eggs, tender broccoli and mature cheddar are baked into a simple frittata that works for lunch or dinner.",
    tags: %w[vegetarian gluten_free]
  },
  {
    title: "Creamy Tomato and Mascarpone Orzo",
    body: "Tender orzo is cooked with tomatoes, mascarpone, basil and parmesan for a comforting one-pan dinner.",
    tags: %w[vegetarian]
  },
  {
    title: "Sweetcorn and Courgette Fritters",
    body: "Crisp sweetcorn and courgette fritters are served with a cooling lime yoghurt and fresh salad.",
    tags: %w[vegetarian gluten_free]
  },

  {
    title: "Lemon and Herb Salmon",
    body: "Salmon fillets are baked with lemon, garlic and herbs and served with roasted baby potatoes and greens.",
    tags: %w[pescatarian gluten_free]
  },
  {
    title: "Prawn and Chilli Linguine",
    body: "Juicy prawns are tossed with linguine, garlic, chilli, cherry tomatoes and fresh parsley.",
    tags: %w[pescatarian]
  },
  {
    title: "Teriyaki Salmon Rice Bowl",
    body: "Sticky teriyaki salmon is served over rice with cucumber, edamame, spring onion and sesame seeds.",
    tags: %w[pescatarian]
  },
  {
    title: "Mediterranean Cod Traybake",
    body: "Cod fillets are roasted with tomatoes, olives, peppers, herbs and baby potatoes.",
    tags: %w[pescatarian gluten_free]
  },
  {
    title: "Tuna and White Bean Salad",
    body: "Tuna, white beans, tomatoes, cucumber and red onion are tossed in a sharp lemon and herb dressing.",
    tags: %w[pescatarian gluten_free]
  },
  {
    title: "Smoked Haddock Fishcakes",
    body: "Flaked smoked haddock and mashed potato are shaped into crisp fishcakes and served with a fresh salad.",
    tags: %w[pescatarian]
  },
  {
    title: "Garlic Prawn Coconut Curry",
    body: "Prawns are simmered in a fragrant coconut curry sauce with garlic, ginger, lime and fresh coriander.",
    tags: %w[pescatarian gluten_free]
  },

  {
    title: "Rosemary Steak and Potato Wedges",
    body: "Seared steak is served with rosemary potato wedges, roasted tomatoes and a peppercorn sauce.",
    tags: %w[ gluten_free]
  },
  {
    title: "Slow-Cooked Beef Chilli",
    body: "Beef mince is slowly cooked with tomatoes, beans, peppers and warming spices until rich and tender.",
    tags: %w[ gluten_free]
  },
  {
    title: "Chicken and Mushroom Pie",
    body: "Tender chicken and mushrooms are cooked in a creamy herb sauce beneath a crisp puff pastry lid.",
    tags: %w[]
  },
  {
    title: "Sticky Honey Garlic Chicken",
    body: "Chicken thighs are glazed with honey, garlic and soy and served with steamed rice and greens.",
    tags: %w[]
  },
  {
    title: "Pork Meatballs with Tomato Sauce",
    body: "Juicy pork meatballs are simmered in a rich tomato and herb sauce and served with spaghetti.",
    tags: %w[]
  },
  {
    title: "Paprika Chicken Traybake",
    body: "Paprika-seasoned chicken is roasted with peppers, onions and baby potatoes in one easy tray.",
    tags: %w[ gluten_free]
  },
  {
    title: "Beef and Broccoli Stir Fry",
    body: "Tender strips of beef and crisp broccoli are cooked in a savoury garlic and ginger sauce.",
    tags: %w[carnivore gluten_free]
  },
  {
    title: "Herb-Roasted Chicken Dinner",
    body: "A herb-roasted chicken breast is served with crispy potatoes, carrots and rich homemade gravy.",
    tags: %w[carnivore gluten_free]
  }
]

Recipe.create!(recipes)

puts "Seed complete!"
puts "Created #{User.count} users."
puts "Created #{Onboarding.count} onboardings."
puts "Created #{Recipe.count} recipes."
puts "Admin login: admin@example.com / #{DEFAULT_PASSWORD}"
