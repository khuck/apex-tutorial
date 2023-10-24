#include <Kokkos_Core.hpp>
#include <cstdio>

int main(int argc, char *argv[])
{


  Kokkos::initialize(argc, argv);

  using team_policy = Kokkos::TeamPolicy<>;
  using team_member = typename team_policy::member_type;
  const team_policy policy(1, 6); // 1 team with 6 threads

  Kokkos::parallel_for(
      "outer",
      policy,
      KOKKOS_LAMBDA(const team_member &thread) {
        const int team_rank = thread.team_rank();

        printf("[1st level] Hello from team rank %i\n", team_rank);

        Kokkos::parallel_for(
            Kokkos::TeamThreadMDRange<Kokkos::Rank<2>, team_member>(thread, 3, 2),
            [=](const int &i, const int &j)
            {
              printf("[2nd level] Hello from team rank %i\n", team_rank);
              printf("i,j = (%i, %i) \n", i, j);
            });

      });

  Kokkos::finalize();
}