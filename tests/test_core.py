from collatz.core import collatz, stopping_time, syracuse, v_sequence


class TestCollatz:
    def test_collatz_1(self):
        assert collatz(1) == [1]

    def test_collatz_2(self):
        assert collatz(2) == [2, 1]

    def test_collatz_7(self):
        assert collatz(7) == [7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]

    def test_collatz_27_length(self):
        traj = collatz(27)
        assert len(traj) == 112
        assert traj[0] == 27
        assert traj[-1] == 1
        assert max(traj) == 9232


class TestSyracuse:
    def test_syracuse_1(self):
        assert syracuse(1) == [1]

    def test_syracuse_7(self):
        assert syracuse(7) == [7, 11, 17, 13, 5, 1]

    def test_syracuse_3(self):
        assert syracuse(3) == [3, 5, 1]


class TestVSequence:
    def test_v_sequence_7(self):
        assert v_sequence(7) == [1, 1, 2, 3, 4]

    def test_v_sequence_3(self):
        assert v_sequence(3) == [1, 4]

    def test_v_sequence_1(self):
        assert v_sequence(1) == []


class TestStoppingTime:
    def test_stopping_time_1(self):
        assert stopping_time(1) == 0

    def test_stopping_time_2(self):
        assert stopping_time(2) == 1

    def test_stopping_time_7(self):
        assert stopping_time(7) == 16

    def test_stopping_time_27(self):
        assert stopping_time(27) == 111
