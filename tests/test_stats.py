from collatz.stats import batch_stopping_times, batch_v_sequences, trajectory_max


class TestBatchStoppingTimes:
    def test_range_1_to_10(self):
        times = batch_stopping_times(1, 10)
        assert times[0] == 0  # stopping_time(1)
        assert times[1] == 1  # stopping_time(2)
        assert times[6] == 16  # stopping_time(7)
        assert len(times) == 10

    def test_known_record(self):
        times = batch_stopping_times(1, 30)
        assert times[26] == 111
        assert max(times) == 111


class TestBatchVSequences:
    def test_range(self):
        seqs = batch_v_sequences(1, 10)
        assert seqs[1] == []
        assert seqs[3] == [1, 4]
        assert seqs[7] == [1, 1, 2, 3, 4]


class TestTrajectoryMax:
    def test_known_peaks(self):
        maxes = trajectory_max(1, 30)
        assert maxes[26] == 9232
        assert maxes[0] == 1
