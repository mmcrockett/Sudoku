var sudoku = angular.module('Sudoku', ['ngResource']);

sudoku.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = jQuery('meta[name=csrf-token]').attr('content');
}]);

sudoku.controller('PuzzleController', ['$scope', '$http', 'Board', function($scope, $http, Board) {
  $scope.stars = [[1],[1,2],[1,2,3]];
  $scope.DisplayBoard = function(size) {
    this.size  = size;
    this.qsize = Math.sqrt(size);
    this.hide  = [[],[],[],[]];
    this.show = function(row, col, difficulty) {
      return (-1 == jQuery.inArray(this.absoluteIndex(row, col), this.hide[difficulty]));
    };

    this.quadrantIndices = function(qnum) {
      var rowIndexStart = Math.floor((qnum / this.qsize)) * this.qsize;
      var colIndexStart = (qnum % this.qsize) * this.qsize;
      var indices = [];

      for(var qrow = 0; qrow < this.qsize; qrow++) {
        for(var qcol = 0; qcol < this.qsize; qcol++) {
          var cindex = colIndexStart + qcol;
          var rindex = rowIndexStart + qrow;
          indices.push(this.absoluteIndex(rindex, cindex));
        }
      }

      return indices;
    };

    this.absoluteIndex = function(row, col) {
      return row * this.size + col;
    };

    this.createDifficulties = function() {
      var quadrants = [];

      for(var i = 0; i < this.size; i++) {
        quadrants.push(i);
      }

      for(var i = 0; i < this.qsize; i++) {
        quadrants.splice(Math.floor(Math.random()*quadrants.length),1);
      }

      for(var i = 0; i < this.size; i++) {
        //1-Star or higher removal...
        var indices = this.quadrantIndices(i);
        var rindex  = Math.floor(Math.random()*indices.length);
        this.hide[1].push(indices[rindex]);
        this.hide[2].push(indices[rindex]);
        this.hide[3].push(indices[rindex]);
        indices.splice(rindex, 1);

        //2-Star or higher removal...
        if (-1 != quadrants.indexOf(i)) {
          rindex  = Math.floor(Math.random()*indices.length);
          this.hide[2].push(indices[rindex]);
          this.hide[3].push(indices[rindex]);
          indices.splice(rindex, 1);

          //3-Star or higher removal...
          rindex  = Math.floor(Math.random()*indices.length);
          this.hide[3].push(indices[rindex]);
          indices.splice(rindex, 1);
        }
      }
    }

    this.createDifficulties();
  };
  $scope.update_difficulty = function(v) {
    $scope.difficulty = v;
    $http.put('/boards/' + v);
  };
  $scope.initialize = function(board, difficulty) {
    $scope.difficulty = difficulty;
    $scope.board = new Board(board);
    $scope.display_board = new $scope.DisplayBoard(board.size);
    $scope.answerValid = [];
  };
  $scope.show = function(row, col) {
    return $scope.display_board.show(row, col, $scope.difficulty);
  };
  $scope.getStyle = function(row, col) {
    var i = $scope.display_board.absoluteIndex(row,col);
    if (1 == $scope.answerValid[i]) {
      return {color:'green'};
    } else if (-1 == $scope.answerValid[i]) {
      return {color:'red'};
    } else {
      return {};
    }
  };
  $scope.isAnswerCorrect = function(row, col, answer) {
    var i = $scope.display_board.absoluteIndex(row,col);
    if (true == _.isFinite(answer)) {
      if (answer == $scope.board.data[row][col]) {
        $scope.answerValid[i] = 1;
      } else {
        $scope.answerValid[i] = -1;
      }
    } else {
      $scope.answerValid[i] = 0;
    }
  };
  $scope.clearStyle = function(row, col) {
    var i = $scope.display_board.absoluteIndex(row,col);
    $scope.answerValid[i] = 0;
  };
  $scope.next = function() {
    $scope.board.$get();
    $scope.display_board = new $scope.DisplayBoard($scope.board.size);
    $scope.answerValid = [];
  };
  $scope.processEnter = function(e) {
    if (13 == e.keyCode) {
      setTimeout(function(){
        jQuery(e.target).blur();
      },0);
    }
  };
}]);

sudoku.factory('Board', ['$resource', function($resource) {
  return $resource('/boards.json', {}, {});
}]);

sudoku.directive('ngBlur', function() {
  return {
    restrict: 'A',
    link: function postLink(scope, element, attrs) {
      element.bind('blur', function () {
        scope.$apply(attrs.ngBlur);
      });
    }
  };
});

sudoku.directive('ngFocus', function() {
  return {
    restrict: 'A',
    link: function postLink(scope, element, attrs) {
      element.bind('focus', function () {
        scope.$apply(attrs.ngFocus);
      });
    }
  };
});
