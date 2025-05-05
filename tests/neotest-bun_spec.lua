local async = require("nio").tests
require("busted")
local inspect = require("inspect")

local adapter = require("neotest-bun")

describe("neotest-bun", function()
	async.it("root", function()
		assert.Equal(adapter.root("."), nil)
	end)

	async.it("is_test_file", function()
		assert.False(adapter.is_test_file(""))
		assert.True(adapter.is_test_file("asdf.test.ts"))
		assert.False(adapter.is_test_file("asdf.testt.ts"))
	end)

	describe("discover_positions", function()
		local assert_test_positions_match = function(expected_output, positions)
			for i, value in ipairs(expected_output) do
				assert.is.truthy(value)
				local position = positions[i + 1][1]
				assert.is.truthy(position)
				assert.Equal(value.name, position.name)
				assert.Equal(value.type, position.type)
			end
		end

		async.it("provides meaningful names from a basic spec", function()
			local positions = adapter.discover_positions("./spec/basic.test.ts"):to_list()

			local expected_output = {
				{
					name = "basic.test.ts",
					type = "file",
				},
				{
					{
						name = "describe text",
						type = "namespace",
					},
					{
						name = "1",
						type = "test",
					},
					{
						name = "2",
						type = "test",
					},
					{
						name = "3",
						type = "test",
					},
					{
						name = "4",
						type = "test",
					},
				},
				{
					{
						name = "describe text 2",
						type = "namespace",
					},
					{
						name = "1",
						type = "test",
					},
					{
						name = "2",
						type = "test",
					},
					{
						name = "3",
						type = "test",
					},
					{
						name = "4",
						type = "test",
					},
				},
			}

			assert.Equal(expected_output[1].name, positions[1].name)
			assert.Equal(expected_output[1].type, positions[1].type)
			assert.Equal(expected_output[2][1].name, positions[2][1].name)
			assert.Equal(expected_output[2][1].type, positions[2][1].type)

			assert.Equal(5, #positions[2])
			for i, value in ipairs(expected_output[2][2]) do
				assert.is.truthy(value)
				local position = positions[2][i + 1][1]
				assert.is.truthy(position)
				assert.Equal(value.name, position.name)
				assert.Equal(value.type, position.type)
				assert.Equal(position.is_parameterized, false)
			end

			assert.Equal(expected_output[3][1].name, positions[3][1].name)
			assert.Equal(expected_output[3][1].type, positions[3][1].type)

			assert.Equal(5, #positions[2])
			assert_test_positions_match(expected_output[2][2], positions[2])

			assert.Equal(5, #positions[3])
			assert_test_positions_match(expected_output[3][2], positions[3])
		end)
	end)

	describe("Process result", function()
		async.it("works", function()
			local str = "inner &amp;gt; middle &amp;gt; outer"
			local splitted_str = str:split(" &amp;gt; ")
			assert.Equal(splitted_str[1], "inner")
			assert.Equal(splitted_str[2], "middle")
			assert.Equal(splitted_str[3], "outer")

			local inspect = require("inspect")
			local xml = [[
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="bun test" tests="2" assertions="1" failures="0" skipped="1" time="0.084069">
  <testsuite name="spec/nestedDescribe.test.ts" tests="2" assertions="1" failures="0" skipped="1" time="0" hostname="Bences-MacBook-Pro.local">
    <testcase name="should do a thing" classname="inner &amp;gt; middle &amp;gt; outer" time="0.000627" file="spec/nestedDescribe.test.ts" assertions="1" />
    <testcase name="this has a &apos;" classname="inner &amp;gt; middle &amp;gt; outer" time="0" file="spec/nestedDescribe.test.ts" assertions="0">
      <skipped />
    </testcase>
  </testsuite>
</testsuites>
			]]
			local result = require("neotest-bun.parse-result").xmlToNeotestResults(xml)
			assert.Equal(
				inspect({
					["spec/nestedDescribe.test.ts::outer::middle::inner::should do a thing"] = {
						status = "passed",
					},
					["spec/nestedDescribe.test.ts::outer::middle::inner::this has a '"] = {
						status = "skipped",
					},
				}),
				inspect(result)
			)
		end)

		async.it("works on example taken from a real project", function()
			local str = "inner &amp;gt; middle &amp;gt; outer"
			local splitted_str = str:split(" &amp;gt; ")
			assert.Equal(splitted_str[1], "inner")
			assert.Equal(splitted_str[2], "middle")
			assert.Equal(splitted_str[3], "outer")

			local xml = [[
<testsuites name="bun test" tests="1" assertions="2" failures="0" skipped="0" time="0.959527">
  <testsuite name="src/app/features/db.test.ts" tests="1" assertions="2" failures="0" skipped="0" time="0.006" hostname="Bences-MacBook-Pro.local">
    <testcase name="handles the test db properly, resets it between test runs, and allows interaction" classname="postgres" time="0.006859" file="src/app/features/db.test.ts" assertions="2" />
  </testsuite>
</testsuites>
			]]
			local result = require("neotest-bun.parse-result").xmlToNeotestResults(xml)
			assert.Equal(
				inspect({
					["src/app/features/db.test.ts::postgres::handles the test db properly, resets it between test runs, and allows interaction"] = {
						status = "passed",
					},
				}),
				inspect(result)
			)
		end)
	end)
end)
