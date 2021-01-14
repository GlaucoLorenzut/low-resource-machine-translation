
# Run fairseq training on Microsoft Azure

## Open student account

1. [URL: Open free student account](https://azure.microsoft.com/en-gb/free/students/)
2. Click _Activate now_
3. University of Maastricht login

   (Installed student version of _MicroSoft Office_ before. There is Microsoft account connected with UM.)
4. _Welcome to the Azure Education Hub!_
5. Click _Explore templates_
6. Click _Linux JuypterHub Student Deployment_
7. At right screen: Click _Deploy_
8. Keep defaults, change following (your own values):

|Parameters|Enter|
|-------------------|--------------------|
|Resourse group|RP1|
|Region|West Europe|
|Admin Username|slsindorf|
|Cpu-gpu|GPU-56GB|
|Authentication type|password|
|Admin Password Or Key|rTgsGgWNeSpr7hkNpvih|

9. Remember _Username_ and _Password_
10. Click _Review + create_
11. Account is created

## Configure account

1. [URL: Log in Azure](https://azure.microsoft.com/en-us/account/)
2. Click _Go to the portal_
3. _Pick an account_
4. University of Maastricht login
5. _Azure services_
6. Click _Ubuntu-Jupyter-GPU-56GB_
7. Click _Public IP address_
8. Select Assignment: _Static_
9. Remember IP address
10. Click _Overview_ and _Ubuntu-Jupyter-GPU-56GB_
11. At _settings_, click _Extensions_
12. Click _+ Add_
13. Click _NVIDIA GPU Driver Extension_. Follow instructions.

## Set up fairseq

1. Go to _Ubuntu-Jupyter-GPU-56GB_
2. At bottom-left click _Serial console_
3. Ubuntu command prompt

   It is also possible to arrive here with _ssh_.  
   For example in Cygwin: ssh -Y slsindorf@104.47.149.111  
   (Use own Username and IP)
4. Install packages and data
   ```
   pip3 install fairseq
   pip3 install sacremoses
   pip3 install tensorboardX
   git clone https://github.com/GiIbert/trans
   ```
   
   Was bit trial and error here.  
   Perhaps _pip3_ does not work.  
   I also installed _python3_, but do not know if that was necessary.
   ```
   sudo apt update
   sudo apt install python3-pip
   ```
   
 ## Run training
 
 1. Go to Ubuntu command prompt, _Serial console_
 2. Set up training directory
    ```
    mkdir -p training/experiment_00  
    cd training/experiment_00
    ```

 3. Write training script _train.sh_
    ```
    CUDA_VISIBLE_DEVICES=0 $HOME/.local/bin/fairseq-train \
    ../../trans/data-bin/ENTAM \
    --task translation \
    --batch-size 48 \
    --arch transformer --encoder-layers 2 --decoder-layers 2 --share-decoder-input-output-embed --encoder-attention-heads 2 --decoder-attention-heads 2 --encoder-embed-dim 512 --decoder-embed-dim 512 \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    --lr 1e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    --dropout 0.25 --weight-decay 0.0001 \
    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens 4096 \
    --tokenizer moses \
    --eval-bleu \
    --eval-bleu-args '{"beam": 5, "max_len_a": 1.2, "max_len_b": 10}' \
    --eval-bleu-detok moses \
    --eval-bleu-remove-bpe \
    --eval-bleu-print-samples \
    --best-checkpoint-metric bleu --maximize-best-checkpoint-metric \
    --save-dir ./checkpoints \
    --tensorboard-logdir ./tensorboard_log \
    --keep-last-epochs 1 \
    --log-format=json --log-interval=10 2>&1 | tee train.log &

4. Get _train.sh_ to Azure training directory

   For example in Cygwin: scp train.sh slsindorf@104.47.149.111:training/experiment_00  
   Or edit and save  _train.sh_ in Azure. (Please tell me how to do that.)
5. From training directory, run:
   ```
   bash train.sh
   ```
6. Training should run now.  
   Check log that GPU NVIDEA driver is found.  
   If training is interrupted it can be restarted and it will continue at epoch where it left.



