@workloads-details-multi-cluster-graph
# don't change first line of this file - the tag is used for the test scripts to identify the test suite

@multi-cluster
@skip
Feature: Kiali Workloads Details minigraph in multicluster setup

  Scenario: Minigraph should not be visible for a service, which is not deployed in specific cluster.
    And user is at the details page for the "workload" "bookinfo/details-v1" located in the "west" cluster
    Then user does not see a minigraph

  Scenario Outline: User should be able to navigate through the graph to remote workloads and services.
    When user is at the details page for the "app" "bookinfo/productpage" located in the "east" cluster
    And user clicks on the "reviews" <type> from the "west" cluster visible in the graph
    Then user is at the details page for the <type> <url> located in the "west" cluster

    Examples:
      | <type>   | <url>               |
      | service  | bookinfo/reviews    |
      | workload | bookinfo/reviews-v3 |

  #this is a regression to this bug (https://github.com/kiali/kiali/issues/6185)
  #I used the sleep namespace in the Gherkin, because I feel like we might need a new demoapp for this scenario,
  #if we don't want to change access to bookinfo namespace in the middle of the test run.
  Scenario: Remote nodes should be restricted if user does not have access rights to a remote namespace
    When user "is" given access rights to a "sleep" namespace located in the "east" cluster  
    And user "is not" given access rights to a "sleep" namespace located in the "west" cluster  
    And user is at the details page for the "workload" "sleep/east" located in the "east" cluster
    Then the nodes located in the "west" cluster should be restricted