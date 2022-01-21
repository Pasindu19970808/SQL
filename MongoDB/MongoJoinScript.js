db.W00101Unit.aggregate([
    {$lookup:
        {
            from:"W03301HAZOPLOPA",
            let:{"matchfield":"$2_UnitNo"},
            pipeline: [
                    {$match:{$expr:{$eq:["$2_Unit","$$matchfield"]}}}
                ],
            as:'W03301result'
        }},
    {$unwind:{path:"$W03301result"}},
//W03301HAZOPLOPA with W03302DeviationGroup
    {$lookup:
        {
            from:"W03302DeviationGroup",
            let:{"matchfield":"$W03301result.Id"},
            pipeline:[
                    {$match:{$expr:{$eq:["$ParentId","$$matchfield"]}}}
                ],
            as:'W03302result'
        }},
    {$unwind:{path:"$W03302result"}},
// W03302DeviationGroup with W03303CauseGroup
    {$lookup:
        {
            from:"W03303CauseGroup",
            let:{"matchfield":"$W03302result.Id"},
            pipeline:[
                  {$match:{$expr:{$eq:["$ParentId","$$matchfield"]}}}                  
                ],
            as:'W03303result'
            
        }},
    {$unwind:{path:"$W03303result"}},
//W03303CauseGroup with W03304ConseqGroup
    {$lookup:
        {
            from:"W03304ConseqGroup",
            let:{"matchfield":"$W03303result.Id"},
            pipeline:[{$match:{$expr:{$eq:["$ParentId","$$matchfield"]}}}
                ],
            as:'W03304result'
        }},
    {$unwind:{path:"$W03304result"}},
//W03304ConseqGroup with W03305ConsCat
    {$lookup:
        {
            from:"W03305ConsCat",
            let:{"matchfield":"$W03304result.Id"},
            pipeline:[{$match:{$expr:{$eq:["$ParentId","$$matchfield"]}}}
                ],
            as:'W03305result'
        }},
    {$unwind:{path:"$W03305result"}},
    {$project:{
      "UnitName":"$3_UnitName",
      "Unit":"$W03301result.2_Unit",
      "Severity":"$W03305result.21_Severity",
      "Likelihood":"$W03305result.22_Likelihood"
    }},
    {$match:{'Likelihood':{$exists:true},'Severity':{$exists:true}}}    
    ])
