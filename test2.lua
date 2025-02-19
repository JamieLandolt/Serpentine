local t = {
    name = "Alice",
    age = 30,
    job = "Engineer"
}

-- Remove the 'age' key-value pair
t["age"] = nil

for k, v in pairs(t) do
    print(k, v)
end