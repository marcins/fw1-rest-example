<cfscript>
testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
testSuite.addAll("tests.testObjectStore");
results = testSuite.run();
writeOutput(results.getResultsOutput('html'));
</cfscript>