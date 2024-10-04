set -ex
source dev.env
ENGINE=faiss
WORKLOAD_NUMBER=small-workload-1
BASE_PATH=/workplace/workspace
DOMAIN_URL_WITH_HTTPS=<DOMAIN_URL_WITH_HTTPS>
PARAMS_FILE=warm/${ENGINE}-cohere-768-dp-${WORKLOAD_NUMBER}.json
TEST_PROCEDURE=no-train-test-index-only
itr=1

echo "Iteration Number: ${itr}"
RESULT_FILE_NAME=result-${WORKLOAD_NUMBER}-${ENGINE}-${itr}.txt
opensearch-benchmark execute-test \
--target-hosts ${DOMAIN_URL_WITH_HTTPS} \
--client-options=timeout:600,amazon_aws_log_in:environment \
--workload-path ${BASE_PATH}/opensearch-benchmark-workloads/vectorsearch \
--workload-params ${BASE_PATH}/opensearch-benchmark-workloads/vectorsearch/params/${PARAMS_FILE} \
--test-procedure ${TEST_PROCEDURE} \
--pipeline benchmark-only \
--kill-running-processes --results-file ${BASE_PATH}/opensearch-benchmark/results/${RESULT_FILE_NAME}


while [ $itr -lt 3 ]
do
# Print the values
echo "Iteration Number: ${itr}"
RESULT_FILE_NAME=result-${WORKLOAD_NUMBER}-${ENGINE}-${itr}.txt
opensearch-benchmark execute-test \
--target-hosts ${DOMAIN_URL_WITH_HTTPS} \
--client-options=timeout:600,amazon_aws_log_in:environment \
--workload-path ${BASE_PATH}/opensearch-benchmark-workloads/vectorsearch \
--workload-params ${BASE_PATH}/opensearch-benchmark-workloads/vectorsearch/params/${PARAMS_FILE} \
--test-procedure ${TEST_PROCEDURE} \
--exclude-tasks "delete-target-index,create-target-index" \
--pipeline benchmark-only \
--kill-running-processes --results-file ${BASE_PATH}/opensearch-benchmark/results/${RESULT_FILE_NAME}
# increment the value
itr=`expr $itr + 1`

done
