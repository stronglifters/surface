#= require models/calculator
describe "Calculator", ->
  it "adds two digits", ->
    expect(new StrongLifters.Calculator().add(2, 2)).toBe(4)
