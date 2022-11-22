pkg load communications
pkg load statistics

for x = 1:3
  fit_f = inline("-0.05 * power(x,2) + 3 * x + 2"); #fitness function
  pop_size = 150; #Setting the population size
  mut_rate = 0.001; #Setting the mutation rate
  c_bit = 6; #Number of bits in chromosome
  gen_iter = 250; #Number of generations to iterate

  population = round(rand(pop_size, c_bit));
  bin_to_dec_population = bi2de(population,'left-msb');
  cost = feval(fit_f, bin_to_dec_population);
  [cost,ind] = sort(cost, 'descend');
  max_c(1) = mean(cost);
  prob = cost / sum(cost);

  gen_count = 0;

  while gen_count < gen_iter
    gen_count = gen_count + 1;
    mating_size = (pop_size / 2);

    parent_1 = randsample(pop_size,mating_size,true,prob);
    parent_2 = randsample(pop_size,mating_size,true,prob);

    cross_point = randi(c_bit - 1);
    population(1:2:pop_size,:) = [population(parent_1,1:cross_point) population(parent_2, cross_point+1:c_bit)];
    population(2:2:pop_size,:) = [population(parent_2,1:cross_point) population(parent_1,cross_point+1:c_bit)];

    no_of_mut = ceil(pop_size-1) * c_bit * mut_rate;

    for i =1:no_of_mut
      col = randi(c_bit);
      row = randi(pop_size);
      if population(row,col) == 1
        population(row,col) = 0
       else
        population(row,col) = 1;
      endif
    endfor

    bin_to_dec_population = bi2de(population,'left-msb');
    cost = feval(fit_f,bin_to_dec_population);
    [cost,ind] = sort(cost, 'descend');
    max_c(gen_count + 1) = max(cost);
    mean_c(gen_count + 1) = mean(cost);
    prob = cost / sum(cost);

    if gen_count > gen_iter || cost(1) > max_c
      break
    endif
   endwhile

    #Display values
    fprintf('Population size = %s\n',num2str(pop_size))
    fprintf('Mutation rate = %s\n',num2str(mut_rate))
    fprintf('Number of Pairs = %s\n',num2str(mating_size))
    fprintf('Generations = %s\n',num2str(gen_count))
    fprintf('Best Cost = %s\n', num2str(cost(1)))
    fprintf('Best Solutions = %s\n',mat2str(int8(population(1,:))))
    fprintf('\n')

    #Create and display plot
    figure(x)
    iters = 0:length(max_c) - 1;
    plot(1: (gen_count + 1), max_c, 1:(gen_count + 1), mean_c);
    xlabel("Generation")
    ylabel("Cost")
endfor


