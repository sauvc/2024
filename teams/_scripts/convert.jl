# Converts a CSV file to a JSON file
# Usage: julia convert.jl <input.csv> <output.json>
#
# Example: CSV file can have the following format
# team-id,team,institution,name,role
# SAUVC-BD-75,IUB Bongomarine,Independent University,Md. Hana Sultan Chowdhury,Member
# SAUVC-BD-75,IUB Bongomarine,Independent University,Md Jahid Hasan,Member
# SAUVC-BD-75,IUB Bongomarine,Independent University,Mukut Protim Memo,Member
# SAUVC-BD-75,IUB Bongomarine,Independent University,Md. Abdun Fattah Lam,Member
#
# The JSON file will have the following format
# [{
#     team_id = "SAUVC-BD-75",
#     team = "IUB Bongomarine",
#     institution = "Independent University",
#     members = ["Md. Hana Sultan Chowdhury", "Md Jahid Hasan", "Mukut Protim Memo", "Md. Abdun Fattah Lam"]
# }]

using CSV
using DataFrames
using Dates
using Statistics
using JSON

function convert(input, output)
    df = CSV.read(input, DataFrame)
    teams = []
    for row in eachrow(df)
        team_id = row.team_id
        team = row.team
        institution = row.institution
        name = row.name
        # if teams contains team_id, append name to members
        # else create a new team
        id = findfirst(t -> t["team-id"] == team_id, teams)
        if isnothing(id)
            push!(teams, Dict("team-id" => team_id, "team" => team, "institution" => institution, "members" => [name]))
        else
            push!(teams[id]["members"], name)
        end
    end
    JSON.open(output, "w") do io
        JSON.print(io, teams)
    end
end

if length(ARGS) != 2
    println("Usage: julia convert.jl <input.csv> <output.json>")
    exit(1)
end

convert(ARGS[1], ARGS[2])