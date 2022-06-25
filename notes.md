DataLoadSimulation works great within the WWI database, however, it does not seem to work well while using it with SqlWorkload. SqlWorkload appears to wait for the proc execution to finish before it begins syncing all of the events.

However, when testing against normal individual transactions...such as simple inserts, and queries, then the realtime replay works great.

There may be some existing procs that can be used to generate data without using the bulk generation proc like "PopulateDataToCurrentDate".

In order to properly demonstrate a workload syncing, it appears the events need to occur externally. SQLQueryStress could be used for this purpose to demonstrate. But that means some sort of data generation query needs to be built and loaded into SQLQueryStress.

Might be able to build something using the existing DataLoadSimulation procs.