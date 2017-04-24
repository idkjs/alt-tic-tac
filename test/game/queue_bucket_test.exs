defmodule AltTicTac1.QueueBucketTest do
    use ExUnit.Case
    alias AltTicTac1.QueueBucket, as: Bucket


    setup do
      {:ok, pid} = Bucket.start_link()
      {:ok, pid: pid}
    end

    test "Should be alive", %{pid: pid} do
      assert alive?(pid) == true
    end
end