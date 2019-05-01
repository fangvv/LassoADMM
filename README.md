## LassoADMM

This is the source code for our paper: **A Distributed ADMM Approach for Collaborative Regression Learning in Edge Computing**. A brief introduction of this work is as follows:

> With the recent proliferation of Internet-of-Things (IoT), enormous amount of data are produced by wireless sensors and connected devices at the edge of network. Conventional cloud computing raises serious concerns on communication latency, bandwidth cost, and data privacy. To address these issues, edge computing has been introduced as a new paradigm that allows computation and analysis to be performed in close proximity with data sources. In this paper, we study how to conduct regression analysis when the training samples are kept private at source devices. Specifically, we consider the lasso regression model that has been widely adopted for prediction and forecasting based on information gathered from sensors. By adopting the Alternating Direction Method of Multipliers (ADMM), we decompose the original regression problem into a set of subproblems, each of which can be solved by an IoT device using its local data information. During the iterative solving process, the participating device only needs to provide some intermediate results to the edge server for lasso training. Extensive experiments based on two datasets are conducted to demonstrate the efficacy and efficiency of our proposed scheme.

You can download our technical report on LassoADMM for reference from [here](http://www.techscience.com/cmc/2019/doi.php?id=5756 "LassoADMM"). We will provide the final version of this work when it is formally published online.

## Required software

Matlab

## Dataset

In our paper, we use the two well-known datasets as follows:

1. https://web.stanford.edu/~boyd/papers/admm/lasso/lasso_example.html
2. https://www4.stat.ncsu.edu/~boos/var.select/diabetes.html

## Citation

If you use these models in your research, please cite:

    @article{Li2019CMC,
  	title = {A Distributed ADMM Approach for Collaborative Regression Learning in Edge Computing},
  	author = {Li, Yangyang and Wang, Xue and Fang, Weiwei and Xue, Feng and Jin, Hao and Zhang, Yi and Li, Xianwei},
  	journal = {CMC: Computers, Materials & Continua},
  	year = {2019},
  	year = {2017},
  	volume = {59},
  	number = {2},
  	pages = {493-508},
  	issn = {1546-2218},
  	doi = {10.32604/cmc.2019.05178},
}

## Contact

Xue Wang (17125239@bjtu.edu.cn)

Weiwei Fang (fangvv@qq.com)

