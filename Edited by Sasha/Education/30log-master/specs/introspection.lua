require 'luacov'
local Class = require '30log'

context('Introspection', function()
  
  context('class:is(aClass)', function()
    test('returns true if class derives straight from aClass',function()
      local class = Class()
      local subclass = class:extends()
      assert_true(subclass:is(class))
    end)
    
    test('checks if class derives from some class deriving from aClass',function()
      local class = Class()
      local subclass1 = class:extends()
      local subclass2 = subclass1:extends()
      local subclass3 = subclass2:extends()
      
      assert_true(subclass3:is(subclass2))
      assert_true(subclass3:is(subclass1))
      assert_true(subclass3:is(class))
      assert_true(subclass2:is(subclass1))      
      assert_true(subclass2:is(class))
      assert_true(subclass1:is(class))

      assert_false(subclass2:is(subclass3))
      assert_false(subclass1:is(subclass3))
      assert_false(subclass1:is(subclass2))
      assert_false(class:is(subclass3))
      assert_false(class:is(subclass2))
      assert_false(class:is(subclass1))
    end)
  end)

  context('obj:is(aClass)', function()
    test('returns true if obj is an instance of aClass',function()
      local class = Class()
      local obj = class()
      assert_true(obj:is(class))      
    end)
    
    test('checks if obj is an instance of some class deriving from aClass',function()
      local class = Class()
      local subclass1 = class:extends()
      local subclass2 = subclass1:extends()
      local subclass3 = subclass2:extends()
      local obj3, obj2, obj1, obj = subclass3(), subclass2(), subclass1(), class()
      
      assert_true(obj3:is(subclass3))
      assert_true(obj3:is(subclass2))
      assert_true(obj3:is(subclass1))
      assert_true(obj3:is(class))
      assert_true(obj2:is(subclass2))
      assert_true(obj2:is(subclass1))
      assert_true(obj2:is(class))      
      assert_true(obj1:is(subclass1))
      assert_true(obj1:is(class))
      assert_true(obj:is(class))
      
      assert_false(obj2:is(subclass3))
      assert_false(obj1:is(subclass3))
      assert_false(obj1:is(subclass2))
      assert_false(obj:is(subclass3))
      assert_false(obj:is(subclass2))
      assert_false(obj:is(subclass1))
    end)
  end)
  
end)