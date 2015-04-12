#= require models/calculator
describe "Calculator", ->
  it "adds two digits", ->
    expect(new SupplyCrow.Calculator().add(2, 2)).toBe(4)
