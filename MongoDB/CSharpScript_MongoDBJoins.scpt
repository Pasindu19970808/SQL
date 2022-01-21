                //CSharp Script to Create pipeline and do MongoDB joins
                var stageone = new BsonDocument().Add("$lookup",
                                                   new BsonDocument().Add("from", "W03301HAZOPLOPA").Add("let", new BsonDocument().Add("matchfield", "$2_UnitNo"))
                                                   .Add("pipeline", new BsonArray().Add(new BsonDocument().Add("$match", new BsonDocument().Add("$expr", new BsonDocument().Add("$eq", new BsonArray { "$2_Unit", "$$matchfield" })))))
                                                   .Add("as", "W03301result"));

                //Stage 2
                //W03301HAZOPLOPA with W03302DeviationGroup
                var stagetwo = new BsonDocument().Add("$lookup",
                                                  new BsonDocument().Add("from", "W03302DeviationGroup").Add("let", new BsonDocument().Add("matchfield", "$W03301result.Id"))
                                                  .Add("pipeline", new BsonArray().Add(new BsonDocument().Add("$match", new BsonDocument().Add("$expr", new BsonDocument().Add("$eq", new BsonArray { "$ParentId", "$$matchfield" })))))
                                                  .Add("as", "W03302result"));

                //Stage 3
                //W03302DeviationGroup with W03303CauseGroup
                var stagethree = new BsonDocument().Add("$lookup",
                                                    new BsonDocument().Add("from", "W03303CauseGroup").Add("let", new BsonDocument().Add("matchfield", "$W03302result.Id"))
                                                    .Add("pipeline", new BsonArray().Add(new BsonDocument().Add("$match", new BsonDocument().Add("$expr", new BsonDocument().Add("$eq", new BsonArray { "$ParentId", "$$matchfield" })))))
                                                    .Add("as", "W03303result"));


                //Stage 4
                //W03303CauseGroup with W03304ConseqGroup
                var stagefour = new BsonDocument().Add("$lookup",
                                                    new BsonDocument().Add("from", "W03304ConseqGroup").Add("let", new BsonDocument().Add("matchfield", "$W03303result.Id"))
                                                    .Add("pipeline", new BsonArray().Add(new BsonDocument().Add("$match", new BsonDocument().Add("$expr", new BsonDocument().Add("$eq", new BsonArray { "$ParentId", "$$matchfield" })))))
                                                    .Add("as", "W03304result"));

                //Stage 5
                //W03304ConseqGroup with W03305ConsCat
                var stagefive = new BsonDocument().Add("$lookup",
                                                    new BsonDocument().Add("from", "W03305ConsCat").Add("let", new BsonDocument().Add("matchfield", "$W03304result.Id"))
                                                    .Add("pipeline", new BsonArray().Add(new BsonDocument().Add("$match", new BsonDocument().Add("$expr", new BsonDocument().Add("$eq", new BsonArray { "$ParentId", "$$matchfield" })))))
                                                    .Add("as", "W03305result"));

                //Projection Stage 
                var projection = new BsonDocument().Add("$project", new BsonDocument().Add("UnitName", "$3_UnitName")
                                                    .Add("Unit", "$W03301result.2_Unit").Add("Severity", "$W03305result.21_Severity")
                                                    .Add("Likelihood", "$W03305result.22_Likelihood")
                                                    .Add("Category", "$W03305result.15_Category"));

                //Exists:True for Likelihood and severity
                var exists = new BsonDocument().Add("$match", new BsonDocument().Add("Likelihood", new BsonDocument("$exists", BsonBoolean.True))
                                                                                .Add("Severity", new BsonDocument("$exists", BsonBoolean.True)));

                var risksummarydata = projectclient.GetDatabase(currentdb).GetCollection<BsonDocument>("W00101Unit")
                                                   .Aggregate<BsonDocument>().AppendStage<BsonDocument>(stageone).Unwind<BsonDocument>("W03301result")
                                                   .AppendStage<BsonDocument>(stagetwo).Unwind<BsonDocument>("W03302result")
                                                   .AppendStage<BsonDocument>(stagethree).Unwind<BsonDocument>("W03303result")
                                                   .AppendStage<BsonDocument>(stagefour).Unwind<BsonDocument>("W03304result")
                                                   .AppendStage<BsonDocument>(stagefive).Unwind<BsonDocument>("W03305result")
                                                   .AppendStage<BsonDocument>(projection).AppendStage<BsonDocument>(exists).ToEnumerable();
