class Workflow
    def initialize(name : String)
        @name = name
        @rules = Array(WorkflowRule).new
    end

    def add_rule(rule : WorkflowRule)
        @rules.push(rule)
    end

    def run_workflow(x : Int32, m : Int32, a : Int32, s : Int32)
        @rules.each() do |rule| 
            result = ""
            case rule.category
            when 'x'
                result = rule.check_condition(x)
            when 'm'
                result = rule.check_condition(m)
            when 'a'
                result = rule.check_condition(a)
            when 's'
                result = rule.check_condition(s)
            when '\0'
                result = rule.check_condition(0)
            else
                result = rule.check_condition(0)
            end
            if result != ""
                return result                
            end
        end
    end
end

class WorkflowRule
    def category
    end

    def check_condition(num : Int32)
    end
end

class WorkflowCondition < WorkflowRule
    def initialize(category : Char, comparator : Char, condition_limit : Int32, result : String)
        @category = category
        @comparator = comparator
        @condition_limit = condition_limit
        @result = result
    end

    def category
        @category
    end

    def check_condition(num : Int)
        case @comparator
        when '<'
            if(num < @condition_limit)
                return @result
            else
                return ""
            end
        when '>'
            if(num > @condition_limit)
                return @result
            else
                return ""
            end
        else
            puts "Unknown comparator #{@comparator}"
        end
    end
end

class WorkflowEnd < WorkflowRule
    def initialize(result : String)
        @result = result
    end

    def category
        '\0'
    end

    def check_condition(num : Int32)
        @result
    end
end

if ARGV.size < 1
    puts "Usage: #{PROGRAM_NAME} <input-file>"
    exit
else
    mode = 0
    workflows = Hash(String, Workflow).new
    parts_rating_sum = 0

    File.each_line(ARGV[0]) do |line|
        if line == ""
            mode+=1
            next
        end
        if mode == 0
            workflow_name = line.split('{')[0]
            workflow_rules = (line.split('{')[1].gsub("}") {""}).split(',')
            workflows[workflow_name] = Workflow.new workflow_name
            workflow_rules.each() do |rule|
                if rule.size > 3
                    category = rule[0]
                    comparator = rule[1]
                    condition_limit = rule[2..].split(':')[0].to_i
                    result = rule[2..].split(':')[1]
                    workflows[workflow_name].add_rule(WorkflowCondition.new(category, comparator, condition_limit, result ))
                else
                    workflows[workflow_name].add_rule(WorkflowEnd.new(rule))
                end
            end 
        else
            x = ((line.gsub("{") {""}).gsub("}") {""}).split(',')[0][2..].to_i
            m = ((line.gsub("{") {""}).gsub("}") {""}).split(',')[1][2..].to_i
            a = ((line.gsub("{") {""}).gsub("}") {""}).split(',')[2][2..].to_i
            s = ((line.gsub("{") {""}).gsub("}") {""}).split(',')[3][2..].to_i
            result = "in"
            
            while result != "A" && result != "R"
                current_workflow = workflows[result]
                result = current_workflow.run_workflow(x, m, a, s)
            end
            if result == "A"
                parts_rating_sum += x + m + a + s
            end
        end
        
    end
    puts "Sum of parts ratings: #{parts_rating_sum}"

end